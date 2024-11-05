//
//  CloneMenu.swift
//  baywatch-app
//
//  Created by thibaut robinet on 25/03/2023.
//

import Foundation
import AppKit

class CloneMenuItem: GitMenuItem {
    let cloneTitle = "baywtach-dotfiles repository is not yet pull"

    required init(coder: NSCoder) {
        super.init(coder: coder)
    }

    init(appDelegate: AppDelegate) {
        super.init(title: self.cloneTitle, action: #selector(appDelegate.noAction), keyEquivalent: "", appDelegate: appDelegate)
        self.state = NSControl.StateValue.off
        self.tag = menuTags.CLONE.rawValue
    }

    override func createSubmenu() {
        let subMenu = NSMenu()
        let clone = NSMenuItem(title: "Git clone", action: #selector(self.appDelegate!.gitClone), keyEquivalent: "c")
        subMenu.addItem(clone)
        self.submenu = subMenu
    }
}

extension AppDelegate {
    @objc func gitClone() {
        print("Execute git clone")

        let path = getBaywatchDotfilesPath()
        if path == nil {
            print("No baywatch-dotfiles repository found")
            return
        }
        cloneBaywatchDotfiles(path: path!)
    }
}

func cloneBaywatchDotfiles(path: URL) {
    let command = "git clone git@github.com:padok-team/baywatch-dotfiles.git"
    if !isSshRequieredPassword() {
        // Clone the repo in background, you does not need to enter the password
        _ = shell(path: path, command)
    } else {
        print("Password is required")
        openPathTerminalAndExecuteCommand(path: path, command: command)
    }
}

func isSshRequieredPassword() -> Bool {
    let dbwUrl = FileManager.default.homeDirectoryForCurrentUser
    let output = shell(path: dbwUrl, "test $(ssh-keygen -y -P '' -f ~/.ssh/id_rsa >/dev/null 2>&1)$? -ne 0 && echo 1 || echo 0" )
    let result = output.dropLast(1)
    let intResult =  Int(result) ?? 1
    let boolResult = intResult != 0
    return boolResult
}
//
// func alertBaywatchCli() {
//    // Create an alert message popup
//    let alert = NSAlert()
//    alert.messageText = "Baywatch cli is not installed!"
//    alert.informativeText = "The use of the application will be degraded."
//    alert.addButton(withTitle: "How to install it ?")
//    alert.addButton(withTitle: "Ok")
//    alert.alertStyle = NSAlert.Style.warning
//    let res = alert.runModal()
//    if res == NSApplication.ModalResponse.alertFirstButtonReturn {
//        // Open the baywatch repository
//        let url = URL(string: "https://github.com/padok-team/baywatch")!
//        NSWorkspace.shared.open(url)
//    }
// }
