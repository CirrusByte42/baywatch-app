//
//  menu.swift
//  baywatch-app
//
//  Created by thibaut robinet on 10/03/2023.
//

import Foundation
import Cocoa
import SwiftUI

public var myUserConfig: userConfig?

func createMenu(app: AppDelegate, titles: [String]) -> NSMenu {
    // read config file
    myUserConfig = getUserConfig()

    // Create menu
    let menu = NSMenu()

    // Add status menu item
    //    let statusItem = newStatusMenu(app: app)
    //    menu.addItem(statusItem)
    menu.addItem(NSMenuItem.separator())

    // Switch menus
    let onCallSwitchItem = newSwitchMenu(app: app, text: "On call :", initial: myUserConfig!.is_oncall)
    let runnerSwitchItem = newSwitchMenu(app: app, text: "Runner :", initial: myUserConfig!.is_runner)
    menu.addItem(runnerSwitchItem)
    menu.addItem(onCallSwitchItem)
    // Create items

    // Add quit button
    menu.addItem(NSMenuItem.separator())
    menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))

    return menu
}
