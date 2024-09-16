//
//  MyMenu.swift
//  baywatch-app
//
//  Created by thibaut robinet on 25/03/2023.
//

import Foundation
import AppKit
import SwiftUI

enum menuTags: Int {
    case CLIENT = 1
    case STATUS = 2
    case CLONE  = 3
}

protocol SearchItemViewEditingDelegate: AnyObject {
    func searchItemViewDidEdit(_ obj: Notification)
}

class BaywatchMenu: NSMenu, NSMenuDelegate, SearchItemViewEditingDelegate {
    func searchItemViewDidEdit(_ obj: Notification) {
        if let searchField = obj.object as? NSSearchField {
            filterMenuItems(with: searchField.stringValue)
        }
    }

    var clientNames: [String] = []

    var currentUserConfig: userConfig = defaultUserConfig()

    var baywatchDotfilesExist: Bool = false

    var appDelegate: AppDelegate?

    func initMenu(appDelegate: AppDelegate) {
        self.appDelegate = appDelegate
        self.delegate = self as NSMenuDelegate
        self.loadData()
        self.build()
    }

    private func loadData() {
        // Load user config:
        currentUserConfig = getUserConfig()

        // Check if dotfiles folder exist
        baywatchDotfilesExist = isBaywatchDotfilesSetuped()

        // Load client Names
        if baywatchDotfilesExist {
            clientNames = clientList().sorted()
        }
    }

    func reloadData() {
        let bde = isBaywatchDotfilesSetuped()
        if self.baywatchDotfilesExist != bde {
            self.refresh()
        } else {
            self.updateStatus()
        }
    }

    func build() {
        self.buildGitMenu()
        self.buildSearchMenu()
        self.buildClientMenu()

        // Add button to open in vscode
        self.addItem(NSMenuItem(title: "VSCode", action: #selector(AppDelegate.vscodeMenu), keyEquivalent: "c"))
        // Add button to access settings
        self.addItem(NSMenuItem(title: "Settings...", action: #selector(AppDelegate.settingsMenu), keyEquivalent: ","))
        // Add refresh button
        self.addItem(NSMenuItem(title: "Refresh", action: #selector(AppDelegate.refreshMenu), keyEquivalent: "r"))
        // Add quit button
        self.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
    }

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

    func buildSearchMenu() {
        let searchBarItem = SearchMenuItem(searchDelegate: self, appDelegate: self.appDelegate!)
        self.addItem(searchBarItem)
    }

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

    func clean() {
        self.items.removeAll(keepingCapacity: true)
    }

    func refresh() {
        loadData()
        clean()
        build()
    }

    func openVscode() {
        let dotfilesPath = getDotfilesPath()
        baywatch_app.openVscode(at: dotfilesPath)
    }

    func settings() {
        print("settings")

    }

    func updateStatus() {
        for item in self.items {
            if item.tag == menuTags.STATUS.rawValue {
                Task {
                    await (item as! StatusMenuItem).update()
                }
            }
        }
    }

    private func filterMenuItems(with query: String) {
        let q = query.lowercased()
        for item in self.items {
            if item.tag == menuTags.CLIENT.rawValue {
                let name = (item as! ClientMenuItem).Name.lowercased()
                if name.contains(q) || q == "" {
                    item.isHidden = false
                } else {
                    // We unselect item only if the filter unselected himself
                    if item.isHighlighted {
                        self.perform(NSSelectorFromString("highlightItem:"), with: nil)
                    }
                    item.isHidden = true
                }
            }
        }
        update()
    }

    func menuNeedsUpdate(_ menu: NSMenu) {
        reloadData()
    }

    func menuWillOpen(_ menu: NSMenu) {
    }

    func menuDidClose(_ menu: NSMenu) {
    }
}

extension AppDelegate {
    @objc func refreshMenu() {
        let menu = self.statusItem.menu as! BaywatchMenu
        menu.refresh()
    }

    @objc func vscodeMenu() {
        let menu = self.statusItem.menu as! BaywatchMenu
        menu.openVscode()
    }

    @objc func settingsMenu() {
        let menu = self.statusItem.menu as! BaywatchMenu
        menu.settings()
    }
}
