//
//  CapsLockManager.swift
//  CapsLockNoDelay
//
//  Created by Guy Kaplan on 31/10/2020.
//

import Foundation
import Cocoa

class CapsLockManager {
    var currentState = false

    /// Requests accessability permissions to enable capturing of keyboard events.
    func requestAccess() -> Bool {
        let options: NSDictionary = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String : true]
        let accessEnabled = AXIsProcessTrustedWithOptions(options)

        if !accessEnabled {
            print("Access Not Enabled")
            return false
        }
        return true
    }
    
    /// Register an event listener and listen for caps-lock presses.
    func registerEventListener() {
        currentState = self.getCapsLockState()
        
        NSEvent.addGlobalMonitorForEvents(matching: [.keyUp, .systemDefined]) { (event) in
            if (event.type != .systemDefined) {
                return
            }
            if (event.subtype.rawValue == 211) {
                if event.data1 != 1 {
                    // Delay is only when turning on, if this is a "disable capslock" press, ignore it.
                    print("setting state \(!self.currentState)")
                    if (!self.currentState) {
                        // Turn on the capslock.
                        self.currentState = true
                    }
                    else {
                        self.currentState = false
                    }
                    self.setCapsLockState(self.currentState)
                }
            }
        }
    }

    func setCapsLockState(_ state: Bool) {
        var ioConnect: io_connect_t = .init(0)
        let ioService = IOServiceGetMatchingService(kIOMasterPortDefault, IOServiceMatching(kIOHIDSystemClass))
        IOServiceOpen(ioService, mach_task_self_, UInt32(kIOHIDParamConnectType), &ioConnect)
        IOHIDSetModifierLockState(ioConnect, Int32(kIOHIDCapsLockState), state)
        IOServiceClose(ioConnect)
    }

    func getCapsLockState() -> Bool {
        var ioConnect: io_connect_t = .init(0)
        let ioService = IOServiceGetMatchingService(kIOMasterPortDefault, IOServiceMatching(kIOHIDSystemClass))
        IOServiceOpen(ioService, mach_task_self_, UInt32(kIOHIDParamConnectType), &ioConnect)

        var modifierLockState = false
        IOHIDGetModifierLockState(ioConnect, Int32(kIOHIDCapsLockState), &modifierLockState)

        IOServiceClose(ioConnect)
        return modifierLockState;
    }
}
