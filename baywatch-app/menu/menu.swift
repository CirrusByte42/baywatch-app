//
//  menu.swift
//  baywatch-app
//
//  Created by thibaut robinet on 10/03/2023.
//

import Foundation
import Cocoa
import SwiftUI

public var myUserConfig : userConfig?  = nil

func createMenu(app : AppDelegate, titles : [String]) -> NSMenu {
    // read config file
    myUserConfig = getUserConfig()

    // Create menu
    let menu = NSMenu()
    
    // Add status menu item
    let statusItem = newStatusMenu(app: app)
    menu.addItem(statusItem)
    menu.addItem(NSMenuItem.separator())
    
    // Switch menus
    let onCallSwitchItem = newSwitchMenu(app : app, text: "On call :", initial: myUserConfig!.is_oncall)
    let runnerSwitchItem = newSwitchMenu(app: app, text: "Runner :", initial: myUserConfig!.is_runner)
    menu.addItem(runnerSwitchItem)
    menu.addItem(onCallSwitchItem)
    
    // Create items
    menu.addItem(NSMenuItem.separator())
    for clientName in titles{
        let item = NSMenuItem(title: clientName, action: #selector(app.baseAction) , keyEquivalent: "")
        item.tag = 1
        item.submenu = submenu(app: app, client: clientName)
        item.isHidden = needToHideClient(user: myUserConfig!, client: clientName)
        menu.addItem(item)
    }
    
    // Add quit button
    menu.addItem(NSMenuItem.separator())
    menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        
    return menu
}

func submenu(app : AppDelegate, client : String) -> NSMenu{
    let menu = NSMenu()
    
    // Create items
    let term = NSMenuItem(title: "Terminal", action: #selector(app.newTerminal) , keyEquivalent: "t")
    let bsetup = NSMenuItem(title: "Setup", action: #selector(app.setup) , keyEquivalent: "s")
    let blogin = NSMenuItem(title: "Login", action: #selector(app.login) , keyEquivalent: "l")
    let bopen = NSMenuItem(title: "Open", action: #selector(app.open) , keyEquivalent: "o")
    let bcheck = NSMenuItem(title: "Check", action: #selector(app.check) , keyEquivalent: "c")
    
    //Disable action if no clientconfig
    let configExist = isClientConfig(client: client)
    print("Client = \(client): configExist \(configExist)")
    if !configExist{
        bsetup.action = nil
        blogin.action = nil
        bopen.action = nil
        bcheck.action = nil
    }
    
    // Populate menu
    menu.addItem(term)
    menu.addItem(bsetup)
    menu.addItem(blogin)
    menu.addItem(bopen)
    menu.addItem(bcheck)
    
    return menu
}
extension AppDelegate{
    @objc func baseAction(item : NSMenuItem) {
        print("Client \(item.title) clicked ! TAG = \(item.tag) ")
    }
    @objc func newTerminal(item : NSMenuItem) {
        openClientTerminal(client: item.parent?.title ?? "")
    }
    @objc func setup(item : NSMenuItem) {
        baywatchsetupInClientTerminal(client: item.parent?.title ?? "")
    }
    @objc func login(item : NSMenuItem) {
        baywatchloginInClientTerminal(client: item.parent?.title ?? "")
    }
    @objc func open(item : NSMenuItem) {
        baywatchopenInClientTerminal(client: item.parent?.title ?? "")
    }
    @objc func check(item : NSMenuItem) {
        baywatchcheckInClientTerminal(client: item.parent?.title ?? "")
    }
}
