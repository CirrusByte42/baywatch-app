//
//  ClientMenuItem.swift
//  baywatch-app
//
//  Created by thibaut robinet on 25/03/2023.
//

import Foundation
import AppKit

struct command {
    var title: String
    var action: Selector?
    var shortcut: String
    var showAlways: Bool
}

class ClientMenuItem: NSMenuItem {

    var appDelegate: AppDelegate?
    var Name: String = ""
    var baywatchDotfilesExist: Bool = false
    var asConfig: Bool = false

    let Commands: [command] = [
        {command(title: "Terminal", action: #selector(AppDelegate.terminal), shortcut: "t", showAlways: true)}(),
        {command(title: "VSCode", action: #selector(AppDelegate.code), shortcut: "c", showAlways: true)}(),
        {command(title: "Documentation", action: #selector(AppDelegate.doc), shortcut: "d", showAlways: true)}()
    ]

    required init(coder: NSCoder) {
        super.init(coder: coder)
    }

    init(clientName: String, appDelegate: AppDelegate) {
        self.Name = clientName
        self.appDelegate = appDelegate
        self.asConfig = isClientAsConfig(client: clientName)

        super.init(title: self.Name, action: #selector(AppDelegate.noAction), keyEquivalent: "")

        self.tag = menuTags.CLIENT.rawValue
        createSubmenu()
    }

    func createSubmenu() {
        let submenu = NSMenu()

        // Create items
        for com in Commands {
            let action = self.asConfig || com.showAlways ? com.action : nil
            let item = NSMenuItem(title: com.title, action: action, keyEquivalent: com.shortcut)
            submenu.addItem(item)
        }
        self.submenu = submenu
    }

    func onCheckStatusUnknown() {
        self.offStateImage = NSImage(named: NSImage.statusNoneName)// "⚪️"
    }

    func onCheckSucess() {
        self.offStateImage = NSImage(named: NSImage.statusAvailableName) // "🟢"
    }

    func onCheckFailed() {
        self.offStateImage = NSImage(named: NSImage.statusUnavailableName) // "🔴"
    }

    //    TODO - Setup a file to save last_check status to print the good color
    //    Usage example
    //    let parentItem = item.parent as! ClientMenuItem
    //    parentItem.onCheckFailed()
    //    parentItem.onCheckSucess()
}

extension AppDelegate {
    @objc func terminal(item: NSMenuItem) {
        openClientTerminal(client: item.parent?.title ?? "")
    }
    @objc func code(item: NSMenuItem) {
        openClientVScode(client: item.parent?.title ?? "")
    }
    @objc func doc(item: NSMenuItem) {
        openDoc(client: item.parent?.title ?? "")
    }
}
