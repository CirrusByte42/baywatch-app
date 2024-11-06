//
//  GitStatusMenuItem.swift
//  baywatch
//
//  Created by thibaut robinet on 12/03/2023.
//

import Foundation
import Cocoa
import SwiftUI
import AppKit

class GitStatusMenuItem: GitMenuItem {

    let fetchingTitle = "Fetching status...                                 "
    let noRepositoryTitle = "No repository found."
    let greenTitle = "Repo is up to date."
    let redTitle = "Repo is out of sync, "

    var status: Bool = true

    required init(coder: NSCoder) {
        super.init(coder: coder)
    }

    init() {
        let currentTitle = (status) ? greenTitle : redTitle
        super.init(title: currentTitle, action: #selector(AppDelegate.noAction), keyEquivalent: "")
        self.state = status ? NSControl.StateValue.on : NSControl.StateValue.off
        self.tag = menuTags.STATUS.rawValue
    }

    override func createSubmenu() {
        let subMenu = NSMenu()
        let action: Selector? = self.status ? nil : #selector(AppDelegate.gitPull)
        let clone = NSMenuItem(title: "Git pull", action: action, keyEquivalent: "p")
        subMenu.addItem(clone)
        self.submenu = subMenu
    }

    // Async function to update the status item without lag
    func update() {
        self.title = fetchingTitle
        self.state = NSControl.StateValue.off
        DispatchQueue.global().async {
            // Avoid computing status if there is no repository
            let path = getBaywatchDotfilesPath()
            if path == nil {
                print("No baywatch-dotfiles repository found")
                self.title = self.noRepositoryTitle
                self.state = NSControl.StateValue.off
            } else {
                // Get repository status
                self.status = isBaywatchDotfilesRepositoryUpToDate()

                // Update the UI on the main thread after fetching the status
                DispatchQueue.main.async {
                    if self.status {
                        self.title = self.greenTitle
                        self.state = NSControl.StateValue.on
                        self.submenu?.items[0].action = self.status ? nil : #selector(AppDelegate.gitPull)
                    } else {
                        let commitBehind = commitBehindCount()
                        let customRedTitle = self.redTitle + " \(commitBehind) commits behind"
                        self.title = customRedTitle
                        self.state = NSControl.StateValue.off
                    }
                }
            }
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
            _ = shell(path: path!, command)
            //            print("cloning ...", path?.relativePath, out)
        } else {
            print("Password is required")
            openPathTerminalAndExecuteCommand(path: path!, command: command)
        }
        return
    }
}

func commitBehindCount() -> Int {
    let path = getBaywatchDotfilesPath()
    if path == nil {
        print("No baywatch-dotfiles repository found")
        return -1
    }
    let countString = shell(path: path!, "git rev-list --count HEAD..origin/main")
    let count = Int(countString.trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0
    print("\(count) commit behind")
    return count
}
