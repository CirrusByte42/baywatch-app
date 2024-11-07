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
    
    func setLoadingStatus() {
        self.title = fetchingTitle
        self.state = NSControl.StateValue.off
        self.offStateImage = NSImage(named: NSImage.statusPartiallyAvailableName) // "🟠"
    }
    
    func setUnkonwnStatus() {
        self.title = self.noRepositoryTitle
        self.state = NSControl.StateValue.off
        self.offStateImage = NSImage(named: NSImage.statusNoneName) // "⚪️"
    }
    
    func setOnStatus(){
        self.title = self.greenTitle
        self.state = NSControl.StateValue.on
        self.submenu?.items[0].action = nil
    }
    
    func setOffStatus(){
        let commitBehind = commitBehindCount()
        let customRedTitle = self.redTitle + " \(commitBehind) commits behind"
        self.title = customRedTitle
        self.state = NSControl.StateValue.off
        self.offStateImage = NSImage(named: NSImage.statusUnavailableName) // "🔴"
        self.submenu?.items[0].action = #selector(AppDelegate.gitPull)
        self.submenu?.items[0].isEnabled = true
    }
    
    func update() {
        self.setLoadingStatus()
        self.updateRepoStatus()
    }

    // Async function to see if the baywatch path is a git repository
    func updateRepoStatus() {
        DispatchQueue.global().async {
            // Avoid computing status if there is no
            let notRepo = !isInsideGitRepo()
            DispatchQueue.main.async {
                if notRepo {
                    print("Path is not a current git repository.")
                    self.setUnkonwnStatus()
                } else {
                    self.isRepoUptodate()
                }
            }
        }
    }

    // Async function tocheck if the baywatch repo is up to date 
    func isRepoUptodate() {
        DispatchQueue.global().async {
            // Get repository status
            self.status = isBaywatchDotfilesRepositoryUpToDate()
            DispatchQueue.main.async {
                if self.status {
                    self.setOnStatus()
                } else {
                    self.setOffStatus()
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
        print("No baywatch-dotfiles path definded")
        // TODO fix the bug in those conditions
        return -1
    }
    let countString = shell(path: path!, "git rev-list --count HEAD..origin/main")
    let count = Int(countString.trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0
    print("\(count) commit behind")
    return count
}

func isInsideGitRepo() -> Bool {
    let path = getBaywatchDotfilesPath()
    if path == nil {
        print("No baywatch-dotfiles path definded")
        return false
    }
    let boolString = shell(path: path!, "git rev-parse --is-inside-work-tree")
    let bool = boolString.trimmingCharacters(in: .whitespacesAndNewlines) == "true"
    print("Is a git repository ? \(bool)")
    return bool
}
