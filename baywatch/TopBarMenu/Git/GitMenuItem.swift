//
//  GitMenuItem.swift
//  baywatch
//
//  Created by thibaut robinet on 25/03/2023.
//

import Foundation
import AppKit

class GitMenuItem: NSMenuItem {
    var baywatchDotfilesExist: Bool = false

    required init(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(title: String, action selector: Selector?, keyEquivalent charCode: String) {
        super.init(title: title, action: selector, keyEquivalent: charCode)
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
    // Add status menu item
    func buildGitMenu() {
        let gitMenu: GitMenuItem
        if baywatchDotfilesExist {
            gitMenu = GitStatusMenuItem()
            (gitMenu as! GitStatusMenuItem).update()
        } else {
            gitMenu = GitCloneMenuItem()
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
    print("Current sha: \(sha)")
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
    print("Latest remote sha: \(sha)")
    return sha
}

func isBaywatchDotfilesRepositoryUpToDate() -> Bool {
    let currentSha = getHeadCurrentSha()
    let lastSha = getLatestRemoteSha()
    if currentSha == lastSha {
        print("Baywatch-dotfiles repository is up to date")
        return true
    }
    print("Baywatch-dotfiles repository is not up to date")
    return false
}
