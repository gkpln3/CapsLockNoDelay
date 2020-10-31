//
//  CapsLockManager.swift
//  CapsLockNoDelay
//
//  Created by Guy Kaplan on 31/10/2020.
//

import Foundation

class CapsLockManager {
    var ioConnect: io_connect_t = .init(0)
    let ioService = IOServiceGetMatchingService(kIOMasterPortDefault, IOServiceMatching(kIOHIDSystemClass))
    IOServiceOpen(ioService, mach_task_self_, UInt32(kIOHIDParamConnectType), &ioConnect)

    var modifierLockState = false
    IOHIDGetModifierLockState(ioConnect, Int32(kIOHIDCapsLockState), &modifierLockState)

    modifierLockState.toggle()
    //        modifierLockState = state
    IOHIDSetModifierLockState(ioConnect, Int32(kIOHIDCapsLockState), modifierLockState)

    IOServiceClose(ioConnect)

    init() {
        
    }
}
