//
//  AppDelegate.swift
//  baywatch-app
//
//  Created by thibaut robinet on 09/03/2023.
//

import Cocoa
import SwiftUI

// To use logo asset
extension NSImage.Name {
    static let logo = NSImage.Name("logo")
    static let logo_mini = NSImage.Name("logo_mini")
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        print("Initialisation start ...")
        // 0 - Create the StatusBarItem and set the logo
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let button = statusItem.button {
            let logoIcon = NSImage(named: NSImage.Name("logo_mini"))
            button.image = logoIcon
        }
        
        // 1 - Check if env is well configured
        print("Check config start ...")
        if !isSetuped(){
            baywatch_app.setup()
        }
        print("Check config finished")
        
        // 2 - Create the menu bar
        let menu = BaywatchMenu()
        menu.initMenu(appDelegate: self)
        statusItem.menu = menu

        print("Initialisation finished")
    }
}
