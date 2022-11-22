//
//  AppDelegate.swift
//  CapsLockNoDelay
//
//  Created by Guy Kaplan on 31/10/2020.
//

import Cocoa
import ServiceManagement

class AppDelegate: NSObject, NSApplicationDelegate {
    var capsLockManager: Toggleable? = nil
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if (checkIfAppIsAlreadyRunning()) {
            // Show an alert and quit.
            let alert = NSAlert()
            alert.messageText = "CapsLockNoDelay is already running."
            alert.alertStyle = .warning
            alert.addButton(withTitle: "OK")
            alert.runModal()
            NSApplication.shared.terminate(self)
        }

//        if (!checkIfRunningFromApplicationsFolder()) {
//            // Prompt the user to move the app to the Applications folder.
//            let alert = NSAlert()
//            alert.messageText = "Would you like to move CapsLockNoDelay to the applications forlder?"
//            alert.alertStyle = .warning
//            alert.addButton(withTitle: "Yes")
//            alert.addButton(withTitle: "No")
//            let response = alert.runModal()
//            if (response == .alertFirstButtonReturn) {
//                moveApplicationToApplicationsFolder()
//
//                // Run the app from the applications folder and terminate.
//                NSWorkspace.shared.launchApplication("/Applications/CapsLockNoDelay.app")
//                NSApplication.shared.terminate(self)
//            }
//        }

        if (!hasAccessibilityPermission()) {
            askForAccessibilityPermission()
        }
        
        if !checkIfCapsLockIsAssignedToLayoutSwitching() {
            self.capsLockManager = CapsLockManager()
        }
        else {
            // I did not observe delays when switching layouts.
            // Enabling this when there are no delays may cause bugs.
//            self.capsLockManager = InputSourceManager()
        }
        
        // Start listening for events.
        registerEventListener()
    }
    
    /// Register an event listener and listen for caps-lock presses.
    func registerEventListener() {
        NSEvent.addGlobalMonitorForEvents(matching: [.keyUp, .systemDefined]) { (event) in
            if (event.type != .systemDefined) {
                return
            }
            if (event.subtype.rawValue == 211) {
                if event.data1 != 1 {
                    self.capsLockManager?.toggleState()
                }
            }
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    private func hasAccessibilityPermission() -> Bool {
        let promptFlag = kAXTrustedCheckOptionPrompt.takeRetainedValue() as NSString
        let myDict: CFDictionary = NSDictionary(dictionary: [promptFlag: false])
        return AXIsProcessTrustedWithOptions(myDict)
    }

    private func askForAccessibilityPermission() {
        let alert = NSAlert.init()
        alert.messageText = "CapsLockNoDelay requires accessibility permissions."
        alert.informativeText = "Please re-launch CapsLockNoDelay after you've granted permission in system preferences."
        alert.addButton(withTitle: "Configure Accessibility Settings")
        alert.alertStyle = NSAlert.Style.warning

        if alert.runModal() == .alertFirstButtonReturn {
            guard let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility") else {
                return
            }
            NSWorkspace.shared.open(url)
            NSRunningApplication.runningApplications(withBundleIdentifier: "com.apple.systempreferences").first?.activate(options: .activateIgnoringOtherApps)
            NSApplication.shared.terminate(self)
        }
    }

    private func checkIfAppIsAlreadyRunning() -> Bool {
        let bundleIdentifier = Bundle.main.bundleIdentifier!
        let runningApps = NSWorkspace.shared.runningApplications
        let isRunning = !runningApps.filter { $0.bundleIdentifier == bundleIdentifier && $0.processIdentifier != getpid() }.isEmpty
        return isRunning
    }

    private func checkIfRunningFromApplicationsFolder() -> Bool {
        let bundlePath = Bundle.main.bundlePath
        let appPath = "/Applications/"
        return bundlePath.hasPrefix(appPath)
    }

    private func moveApplicationToApplicationsFolder() {
        let bundlePath = Bundle.main.bundlePath
        let appPath = "/Applications/"
        let appName = "CapsLockNoDelay.app"
        let newPath = appPath + appName
        do {
            try FileManager.default.moveItem(atPath: bundlePath, toPath: newPath)
        } catch {
            let alert = NSAlert()
            alert.messageText = "Failed to move CapsLockNoDelay to the applications forlder."
            alert.informativeText = error.localizedDescription
            alert.alertStyle = .warning
            alert.addButton(withTitle: "OK")
            alert.runModal()
            NSApplication.shared.terminate(self)
        }
    }
    
    private func checkIfCapsLockIsAssignedToLayoutSwitching() -> Bool {
        let command = "defaults read -g TISRomanSwitchState"
        let task = Process()
        task.launchPath = "/bin/bash"
        task.arguments = ["-c", command]
        let pipe = Pipe()
        task.standardOutput = pipe
        task.launch()
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)
        return output?.trimmingCharacters(in: .whitespacesAndNewlines) == "1"
    }
}

