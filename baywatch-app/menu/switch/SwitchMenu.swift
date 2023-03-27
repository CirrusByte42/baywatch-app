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

enum SwitchNames: String{
    case RUNNER = "Runner :"
    case ONCALL = "On call :"
}

class SwitchMenuItem : NSMenuItem {

    var appDelegate : AppDelegate?
    var value : Bool = false

    required init(coder: NSCoder) {
        super.init(coder: coder)
    }

    init(switchText: SwitchNames, appDelegate: AppDelegate, initalValue: Bool) {
        self.appDelegate = appDelegate
        self.value = initalValue
        super.init(title: "", action: nil, keyEquivalent: "")
    
        self.tag = menuTags.SWITCH.rawValue
        buildView(switchText: switchText)
    }
    
    func buildView(switchText: SwitchNames){
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
        textView.string = switchText.rawValue
        viewHint.addSubview(textView)
        
        // Create the switch object
        let switchFrame = CGRect(x: 60, y: 0, width: 80, height: 30)
        let switchButton = NSSwitch(frame: switchFrame)
        switchButton.action = #selector(AppDelegate.switchValueDidChange)
        switchButton.identifier = NSUserInterfaceItemIdentifier(switchText.rawValue)
        
        if self.value {
            switchButton.state = NSControl.StateValue.on
        }
        viewHint.addSubview(switchButton)
        self.view = viewHint
    }
}


func newSwitchMenu(app : AppDelegate, text : String, initial: Bool) -> NSMenuItem {
    
    // Create main switch menu item objets
    let switchItem = NSMenuItem()

//    print(app)
//    switchItem.action = Selector("switchValueDidChange")

    return switchItem
}

extension AppDelegate{
    @objc func switchValueDidChange(mswitch: NSSwitch) {
        let menu = self.statusItem.menu as! BaywatchMenu
        
        let value = mswitch.state.rawValue
        let identity = mswitch.identifier!.rawValue
        print("\(identity) -> \(value)")
        switch identity{
        case SwitchNames.RUNNER.rawValue:
            menu.currentUserConfig.is_runner = value != 0
        case SwitchNames.ONCALL.rawValue:
            menu.currentUserConfig.is_oncall = value != 0
        default:
            print("Error", menu.currentUserConfig)
        }
        updateConfig(config: menu.currentUserConfig)

        menu.hideClients()
    }
}
