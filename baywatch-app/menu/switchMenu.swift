//
//  switch_menu.swift
//  baywatch-app
//
//  Created by thibaut robinet on 10/03/2023.
//

import Foundation
import Cocoa
import SwiftUI
import os

func newSwitchMenu(app : AppDelegate, text : String, initial: Bool) -> NSMenuItem {
    
    // Create main switch menu item objets
    let switchItem = NSMenuItem()
    let frame = CGRect(x: 0, y: 0, width: 140, height: 30)
    let viewHint = NSView(frame: frame)
    
    // Create the TextView part of the switch menu item
    let textViewFrame = CGRect(x: 10, y: -8, width: 60, height: 30)
    let textStorage = NSTextStorage()
    let layoutManager = NSLayoutManager()
    textStorage.addLayoutManager(layoutManager)
    let textContainer = NSTextContainer(containerSize: textViewFrame.size)
    layoutManager.addTextContainer(textContainer)
    let textView = NSTextView(frame: textViewFrame, textContainer: textContainer)
    textView.isEditable = true
    textView.isSelectable = true
    textView.backgroundColor = .clear
    textView.string = text
    viewHint.addSubview(textView)
    
    // Create the switch object
    let switchFrame = CGRect(x: 60, y: 0, width: 80, height: 30)
    let switchButton = NSSwitch(frame: switchFrame)
    switchButton.action = #selector(app.switchValueDidChange)
    switchButton.identifier = NSUserInterfaceItemIdentifier(text)
    
    if initial == true {
        switchButton.state = NSControl.StateValue.on
    }
    viewHint.addSubview(switchButton)
    switchItem.view = viewHint
//    print(app)
//    switchItem.action = Selector("switchValueDidChange")

    return switchItem
}

extension AppDelegate{
    @objc func switchValueDidChange(mswitch: NSSwitch) {
        let value = mswitch.state.rawValue
        let identity = mswitch.identifier!.rawValue
        print("\(identity) -> \(value)")
        switch identity{
        case "Runner :":
            print("RUNNER", myUserConfig!)
            myUserConfig!.is_runner = value != 0
        case "On call :":
            print("ONCALL", myUserConfig!)
            myUserConfig!.is_oncall = value != 0
        default:
            print("Error", myUserConfig!)
        }
//        myUserConfig
        updateConfig(config: myUserConfig!)
        refreshMenu()
    }
}
