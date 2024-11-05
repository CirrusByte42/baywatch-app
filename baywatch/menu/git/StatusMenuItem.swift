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

class StatusMenuItem: GitMenuItem {
    let greenTitle = "baywtach-dotfiles is up to date"
    let redTitle = "baywtach-dotfiles behind"

    var status: Bool = true

    required init(coder: NSCoder) {
        super.init(coder: coder)
    }

    init(appDelegate: AppDelegate) {
        let currentTitle = (status) ? greenTitle : redTitle

        super.init(title: currentTitle, action: #selector(appDelegate.noAction), keyEquivalent: "", appDelegate: appDelegate)

        self.state = status ? NSControl.StateValue.on : NSControl.StateValue.off
        self.tag = menuTags.STATUS.rawValue
    }

    override func createSubmenu() {
        let subMenu = NSMenu()
        let action: Selector? = self.status ? nil : #selector(self.appDelegate!.gitPull)
        let clone = NSMenuItem(title: "Git pull", action: action, keyEquivalent: "p")
        subMenu.addItem(clone)
        self.submenu = subMenu
    }

    func update(appDelegate: AppDelegate) async {
        let newStatus = isBaywatchDotfilesRepositoryUpToDate()
        if newStatus != self.status {
            self.status = newStatus
            self.title = self.status ? greenTitle : redTitle
            self.state = self.status ? NSControl.StateValue.on : NSControl.StateValue.off
            self.submenu?.items[0].action = self.status ? nil : #selector(self.appDelegate!.gitPull)
        }
    }
}

extension AppDelegate {
    @objc func gitPull() {
        let command = "git pull"
        let path = getBaywatchDotfilesPath()
        if path == nil {
            print("No baywatch-dotfiles repository found")
            return
        }
        if !isSshRequieredPassword() {
            // Clone the repo in background, you does not need to enter the password
            let out = shell(path: path!, command)
            //            print("cloning ...", path?.relativePath, out)
        } else {
            print("Password is required")
            openPathTerminalAndExecuteCommand(path: path!, command: command)
        }
        return
    }
}
