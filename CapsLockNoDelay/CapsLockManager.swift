//
//  CapsLockManager.swift
//  CapsLockNoDelay
//
//  Created by Guy Kaplan on 31/10/2020.
//

import Foundation

class CapsLockManager: Toggleable {
    var currentState = false
    
    init() {
        currentState = Self.getCapsLockState()
    }
    
    public func toggleState() {
        print("setting state \(!self.currentState)")
        self.setCapsLockState(!self.currentState)
    }
    
    public func setCapsLockState(_ state: Bool) {
        self.currentState = state
        var ioConnect: io_connect_t = .init(0)
        let ioService = IOServiceGetMatchingService(kIOMasterPortDefault, IOServiceMatching(kIOHIDSystemClass))
        IOServiceOpen(ioService, mach_task_self_, UInt32(kIOHIDParamConnectType), &ioConnect)
        IOHIDSetModifierLockState(ioConnect, Int32(kIOHIDCapsLockState), state)
        IOServiceClose(ioConnect)
    }

    public static func getCapsLockState() -> Bool {
        var ioConnect: io_connect_t = .init(0)
        let ioService = IOServiceGetMatchingService(kIOMasterPortDefault, IOServiceMatching(kIOHIDSystemClass))
        IOServiceOpen(ioService, mach_task_self_, UInt32(kIOHIDParamConnectType), &ioConnect)

        var modifierLockState = false
        IOHIDGetModifierLockState(ioConnect, Int32(kIOHIDCapsLockState), &modifierLockState)

        IOServiceClose(ioConnect)
        return modifierLockState;
    }
}
