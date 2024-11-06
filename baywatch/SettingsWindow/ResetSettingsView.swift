//
//  ResetSettingsView.swift
//  baywatch
//
//  Created by thibaut robinet on 04/11/2024.
//

import AppKit
import KeyboardShortcuts

class ResetSettingsView: NSButton, SettingsView {

    init() {
        super.init(frame: NSRect(x: 300, y: 20, width: 60, height: 20))
        self.title = "Reset config"
        self.target = self
        self.action = #selector(resetConfigButton)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func resetConfigButton() {
        // Create the alert
        let alert = NSAlert()
        alert.messageText = "Are you sure you want to reset all settings?"
        alert.informativeText = "This action cannot be undone."
        alert.alertStyle = .warning

        // Add buttons
        alert.addButton(withTitle: "Accept")  // This becomes the default button
        alert.addButton(withTitle: "Cancel")

        // Show the alert as a modal dialog
        let response = alert.runModal()

        // Check which button was clicked
        if response == .alertFirstButtonReturn {
            // Erase action
            resetUserConfig()

            // Refresh setting window
            if let appDelegate = NSApplication.shared.delegate as? AppDelegate {
                appDelegate.refresh()
            }

        } else if response == .alertSecondButtonReturn {
            // Cancel clicked
            print("Reset config has been canceled.")
        }
    }

    func refresh() {
        print("ResetSettingsView: nothing to refresh")
    }
}

func resetUserConfig() {
    UserDefaults.standard.removeObject(forKey: "baywatchDotfilesPath")
    UserDefaults.standard.removeObject(forKey: "termApplication")
    UserDefaults.standard.removeObject(forKey: "coloredTopBarIcon")
    KeyboardShortcuts.setShortcut(_: .init(.l, modifiers: [.command]), for: .openShortcut)
}
