//
//  InputSourceManager.swift
//  CapsLockNoDelay
//
//  Created by Guy Kaplan on 22/11/2022.
//

import Foundation
import Carbon

class InputSourceManager: Toggleable {
    var isABC: Bool
    var lastNonAbsUsedSource: TISInputSource? = nil
    let asciiCapable = TISCreateASCIICapableInputSourceList().takeRetainedValue() as NSArray
    
    init() {
        // The logic should be that caps lock switchs to the last used ABC layout (ascii capable)
        isABC = asciiCapable.contains(Self.getCurrentInputSource())
    }
    
    public func toggleState() {
        // Set the input source to the next one in the list
        if self.isABC {
            if let lastNonAbsUsedSource = lastNonAbsUsedSource {
                self.setInputSource(lastNonAbsUsedSource)
            }
            isABC = false
        }
        else {
            let asciiCapable = TISCreateASCIICapableInputSourceList().takeRetainedValue() as NSArray
            if let first = asciiCapable.firstObject {
                if !asciiCapable.contains(Self.getCurrentInputSource()) {
                    lastNonAbsUsedSource = Self.getCurrentInputSource()
                }
                isABC = true
                self.setInputSource(first as! TISInputSource)
            }
        }
    }

    public func setInputSource(_ newSource: TISInputSource) {
        print("Setting \(newSource), isabc \(isABC)")
        TISSelectInputSource(newSource)
    }
    public static func getCurrentInputSource() -> TISInputSource {
        return TISCopyCurrentKeyboardInputSource().takeRetainedValue()
    }
}
