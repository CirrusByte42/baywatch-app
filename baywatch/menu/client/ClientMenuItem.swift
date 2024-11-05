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
        {command(title: "Terminal", action: #selector(AppDelegate.terminal), shortcut: "", showAlways: true)}(),
        {command(title: "VSCode", action: #selector(AppDelegate.code), shortcut: "", showAlways: true)}(),
        {command(title: "Documentation", action: #selector(AppDelegate.doc), shortcut: "", showAlways: true)}()
    ]

    required init(coder: NSCoder) {
        super.init(coder: coder)
    }

    init(clientName: String, appDelegate: AppDelegate) {
        self.Name = clientName
        self.appDelegate = appDelegate
        self.asConfig = isClientAsConfig(client: clientName)

        super.init(title: self.Name, action: #selector(AppDelegate.noAction), keyEquivalent: "")

        if !self.asConfig {
            self.onNoBaywatchConfig()
        }
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

    func onNoBaywatchConfig() {
        self.offStateImage = NSImage(named: NSImage.statusUnavailableName) // "🔴"
    }
}

extension AppDelegate {
    @objc func terminal(item: NSMenuItem) {
        let clientPath = getClientPath(client: item.parent?.title ?? "")
        openTerminal(at: clientPath)
    }
    @objc func code(item: NSMenuItem) {
        openVscode(at: getClientPath(client: item.parent?.title ?? ""))
    }
    @objc func doc(item: NSMenuItem) {
        openDoc(client: item.parent?.title ?? "")
    }
}

extension BaywatchMenu {
    func buildClientMenu() {
        if baywatchDotfilesExist {
            if self.clientNames.count > 0 {
                for client in self.clientNames {
                    let clientItem = ClientMenuItem(clientName: client, appDelegate: self.appDelegate!)
                    self.addItem(clientItem)
                }
                self.addItem(NSMenuItem.separator())
            }
        }
        self.addItem(NSMenuItem.separator())
    }
}

func getClientPath(client: String) -> URL {
    var baywatchdotfilesPath = getBaywatchDotfilesPath()
    if baywatchdotfilesPath == nil {
        let homeDir = FileManager.default.homeDirectoryForCurrentUser
        baywatchdotfilesPath = homeDir.appendingPathComponent(".baywatch/baywatch-dotfiles")
    }
    let defaultPath = "/\(client)"
    let configUrl = baywatchdotfilesPath!.appendingPathComponent(defaultPath)
    return configUrl
}
