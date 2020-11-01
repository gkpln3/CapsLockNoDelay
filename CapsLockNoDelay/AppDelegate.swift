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
        // Request accessability permissions.
        if (!capsLockManager.requestAccess()) {
            exit(1)
        }
        
        // Start listening for events.
        self.capsLockManager.registerEventListener()
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}

