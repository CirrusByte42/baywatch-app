//
//  DefaultMenu.swift
//  baywatch
//
//  Created by thibaut robinet on 06/11/2024.
//

import AppKit

extension BaywatchMenu {
    func buildDefaultMenu() {
        // Add button to open in vscode
        self.addItem(NSMenuItem(title: "VSCode", action: #selector(AppDelegate.vscodeMenu), keyEquivalent: "c"))
        // Add button to access settings
        self.addItem(NSMenuItem(title: "Settings...", action: #selector(AppDelegate.settingsMenu), keyEquivalent: ","))
        // Add refresh button
        self.addItem(NSMenuItem(title: "Refresh", action: #selector(AppDelegate.refreshMenu), keyEquivalent: "r"))
        // Add quit button
        self.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
    }
}
