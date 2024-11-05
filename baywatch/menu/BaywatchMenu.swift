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

    private func loadData() {
        // Load client Names
        if baywatchDotfilesExist {
            clientNames = clientList().sorted()
        }
    }
    func clientList() -> [String] {
        var clientList: [String] = []

        // Fetching client names
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

    func reloadData() {
        //        let bde = self.user!.isReady()
        //        if self.baywatchDotfilesExist != bde {
        self.refresh()
        //        } else {
        //            self.updateStatus()
        //        }
    }

    func build() {
        //        self.buildGitMenu()
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

    func buildSearchMenu() {
        let searchBarItem = SearchMenuItem(searchDelegate: self, appDelegate: self.appDelegate!)
        self.addItem(searchBarItem)
    }

    func clean() {
        self.items.removeAll(keepingCapacity: true)
    }

    func refresh() {
        loadData()
        clean()
        build()
    }

    //    func updateStatus() {
    //        for item in self.items {
    //            if item.tag == menuTags.STATUS.rawValue {
    //                Task {
    //                    await (item as! StatusMenuItem).update(appDelegate: self.appDelegate!)
    //                }
    //            }
    //        }
    //    }
    //
    func menuNeedsUpdate(_ menu: NSMenu) {
        reloadData()
    }
    func isVisible() -> Bool {
        return menuVisible
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

func getBaywatchDotfilesPath() -> URL? {
    let path = getFavoriteBaywatchDotfilesPath()
    var url: URL?
    if FileManager.default.fileExists(atPath: path) {
        url = URL(fileURLWithPath: path)
    }
    return url
}
