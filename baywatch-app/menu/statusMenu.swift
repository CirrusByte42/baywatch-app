//
//  statusMenu.swift
//  baywatch-app
//
//  Created by thibaut robinet on 12/03/2023.
//

import Foundation
import Cocoa
import SwiftUI
import AppKit

func newStatusMenu(app : AppDelegate) -> NSMenuItem {
    let uptodate = isUpToDate()
    let title = (uptodate) ? "baywtach-dotfiles is up to date" : "baywtach-dotfiles behind"
    
    // Create a item to indicate if the repository is uptodate
    let item = NSMenuItem(title: title, action: #selector(app.noAction) , keyEquivalent: "")
    
    item.state = (uptodate) ? NSControl.StateValue.on : NSControl.StateValue.off
    item.onStateImage = NSImage(named: NSImage.statusAvailableName) //   "🟢"
    item.offStateImage = NSImage(named: NSImage.statusUnavailableName) //    "🔴"
    item.isEnabled = false
    item.submenu = statusSubmenu(app: app, uptodate: uptodate)
    item.submenu?.items[0].isEnabled = false
    
    item.tag = 2

    return item
}
func statusSubmenu(app : AppDelegate, uptodate : Bool) -> NSMenu{
    let menu = NSMenu()
    
    // Create items
    let pull = NSMenuItem(title: "Git pull", action: #selector(app.gitPull) , keyEquivalent: "p")
    if uptodate {
        pull.action = nil
    }
    // Populate menu
    menu.addItem(pull)
    
    return menu
}

extension AppDelegate{
    @objc func noAction() {
        // Do nothing
        return
    }
    @objc func gitPull() {
        _ = shell("git pull")
        refreshStatus()
        return
    }
}
