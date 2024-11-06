//
//  BaywatchMenu.swift
//  baywatch
//
//  Created by thibaut robinet on 25/03/2023.
//

import Foundation
import AppKit
import SwiftUI

// TAGS to know what is itemMenu type
enum menuTags: Int {
    case CLIENT = 1
    case STATUS = 2
    case CLONE  = 3
}

// Folder that are printed in the TopBarMenu
let exceptions: [String] = [".git", ".tmpl", "bin", ".vscode", "0-strat-tech", "1-old-clients"]

protocol SearchItemViewEditingDelegate: AnyObject {
    func searchItemViewDidEdit(_ obj: Notification)
}

class BaywatchMenu: NSMenu, NSMenuDelegate, SearchItemViewEditingDelegate {
    private var menuVisible = false
    var clientNames: [String] = []
    var baywatchDotfilesExist: Bool = false
    var appDelegate: AppDelegate?

    func initMenu(appDelegate: AppDelegate) {
        self.appDelegate = appDelegate
        self.delegate = self as NSMenuDelegate
        self.baywatchDotfilesExist = true
        self.loadData()
        self.build()
    }

    // Sort client list
    private func loadData() {
        if baywatchDotfilesExist {
            clientNames = clientList().sorted()
        }
    }

    // Load client names = load folder in the baywatch-dotfiles path
    func clientList() -> [String] {
        var clientList: [String] = []
        let fm = FileManager.default
        if getBaywatchDotfilesPath() == nil {
            return clientList
        }
        do {
            let items = try fm.contentsOfDirectory(at: getBaywatchDotfilesPath()!, includingPropertiesForKeys: nil)

            for item in items {
                if item.isDirectory {
                    clientList.append(item.lastPathComponent)
                }
            }
            for k in 0...exceptions.count - 1 {
                clientList = clientList.filter { $0 != exceptions[k] }
            }
        } catch {
            print("Error fetching clients \(error)")
            return clientList
        }
        return clientList
    }

    func build() {
        self.buildGitMenu()
        self.buildSearchMenu()
        self.buildClientMenu()
        self.buildDefaultMenu()
    }

    func buildSearchMenu() {
        let searchBarItem = ClientSearchMenuItem(searchDelegate: self, appDelegate: self.appDelegate!)
        self.addItem(searchBarItem)
    }

    func isVisible() -> Bool {
        return menuVisible
    }

    func clean() {
        self.items.removeAll(keepingCapacity: true)
    }

    func refresh() {
        loadData()
        clean()
        build()
    }

    func menuNeedsUpdate(_ menu: NSMenu) {
        self.refresh()
    }

    func menuWillOpen(_ menu: NSMenu) {
        menuVisible = true
    }

    func menuDidClose(_ menu: NSMenu) {
        menuVisible = false
    }
    func searchItemViewDidEdit(_ obj: Notification) {
        if let searchField = obj.object as? NSSearchField {
            filterMenuItems(with: searchField.stringValue)
        }
    }
}

extension AppDelegate {
    @objc func noAction() {
        // Do nothing
        return
    }

    @objc func refreshMenu() {
        let menu = self.statusItem.menu as! BaywatchMenu
        menu.refresh()
    }

    @objc func vscodeMenu() {
        openVscode(at: getBaywatchDotfilesPath())
    }
}
