//
//  GitMenu.swift
//  baywatch-app
//
//  Created by thibaut robinet on 25/03/2023.
//

import Foundation
import AppKit

class GitMenuItem: NSMenuItem {
    var baywatchDotfilesExist: Bool = false
    var appDelegate: AppDelegate?

    required init(coder: NSCoder) {
        super.init(coder: coder)
    }

    init(title: String, action selector: Selector?, keyEquivalent charCode: String, appDelegate: AppDelegate) {
        super.init(title: title, action: selector, keyEquivalent: charCode)
        self.appDelegate = appDelegate
        self.onStateImage = NSImage(named: NSImage.statusAvailableName) // "🟢"
        self.offStateImage = NSImage(named: NSImage.statusUnavailableName) // "🔴"
        self.isEnabled = false
        self.baywatchDotfilesExist = getBaywatchDotfilesPath() != nil && FileManager.default.fileExists(atPath: getBaywatchDotfilesPath()!.path)

        createSubmenu()
    }

    func createSubmenu() {
        return
    }
}

extension BaywatchMenu {
    func buildGitMenu() {
        // Add status menu item
        let gitMenu: GitMenuItem
        if baywatchDotfilesExist {
            gitMenu = StatusMenuItem(appDelegate: self.appDelegate!)
        } else {
            gitMenu = CloneMenuItem(appDelegate: self.appDelegate!)
        }
        self.addItem(gitMenu)
        self.addItem(NSMenuItem.separator())
    }
}

func getHeadCurrentSha() -> String {
    let path = getBaywatchDotfilesPath()
    if path == nil {
        print("No baywatch-dotfiles repository found")
        return ""
    }
    let sha = shell(path: path!, "git rev-parse HEAD")
    return sha
}

func getLatestRemoteSha() -> String {
    let path = getBaywatchDotfilesPath()
    if path == nil {
        print("No baywatch-dotfiles repository found")
        return ""
    }
    // Update remote repository
    _ = shell(path: path!, "git fetch origin")
    // Get the latest sha
    let sha = shell(path: path!, "git rev-parse origin/main")
    return sha
}

func isBaywatchDotfilesRepositoryUpToDate() -> Bool {
    let currentSha = getHeadCurrentSha()
    let lastSha = getLatestRemoteSha()
    if currentSha == lastSha {
        return true
    }
    return false
}
