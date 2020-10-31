//
//  AppDelegate.swift
//  CapsLockNoDelay
//
//  Created by Guy Kaplan on 31/10/2020.
//

import Cocoa
import ServiceManagement

class AppDelegate: NSObject, NSApplicationDelegate {
    let capsLockManager = CapsLockManager()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if SMLoginItemSetEnabled(Bundle.main.bundleIdentifier! as CFString, true) {
            print("Successfully added login item.")
        } else {
            print("Failed to add login item.")
        }
        
        if (!capsLockManager.requestAccess()) {
            exit(1)
        }

        self.capsLockManager.registerEventListener()
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}

