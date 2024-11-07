//
//  SettingsWindow.swift
//  baywatch
//
//  Created by thibaut robinet on 17/09/2024.

import Foundation
import AppKit
import KeyboardShortcuts

protocol SettingsView {
    func refresh()
}

extension AppDelegate: NSWindowDelegate {

    @objc func settingsMenu() {
        // Create the window if it's not already created
        if self.window == nil {
            // Set window size
            let settingsWindow = NSWindow(
                contentRect: NSRect(x: 0, y: 0, width: 400, height: 200),
                styleMask: [.titled, .closable],
                backing: .buffered, defer: false
            )

            // Default properties
            settingsWindow.title = "Settings"
            settingsWindow.center()
            settingsWindow.delegate = self

            // Build view
            settingViewItems = [
                ("Topbar icon: ", EnableColoredTopBarIconView()),
                ("Keyboard shortcut to open baywatch app:", KeyboardShortcuts.RecorderCocoa(for: .openShortcut)),
                ("Default terminal application:", SelectTerminalView()),
                ("Selected Path:", SelectBaywatchDotfilePathView()),
                ("", ResetSettingsView())
            ]
            let settingView = createSettingsView(with: settingViewItems)
            let viewSize = settingView.fittingSize
            settingsWindow.contentView = settingView
            self.window = settingsWindow
            self.window.setContentSize(viewSize)

            // Resize window to fit the settings view
            self.window.center()
        }
        // Show the window and bring it to the front
        self.window?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }

    // This function takes a list of maps (titles, view) of types [(String, NSView)]
    // Then the function create a Staxk view for settings purpose
    //  1. Titles are printed in the first column
    //  2. View are printed in the second column
    //  3 I deal with some constraint to be centered and well aligned, the width is adaptable to the max object of the column
    func createSettingsView(with items: [(String, NSView)] ) -> NSView {
        let container = NSStackView()
        container.orientation = .vertical
        container.alignment = .leading
        container.spacing = 10

        let maxLabelWidth = items.map { (title, _) in
            let labelView = NSTextField(labelWithString: title)
            return labelView.fittingSize.width
        }.max() ?? 0

        // let maxViewWidth = items.map { (_, view) in view.fittingSize.width}.max() ?? 0

        for (labelText, view) in items {
            let rowStack = NSStackView()
            rowStack.orientation = .horizontal
            rowStack.spacing = 10
            rowStack.alignment = .top

            // Create label for the left column with fixed width
            let label = NSTextField(labelWithString: labelText)
            label.alignment = .left
            label.font = NSFont.systemFont(ofSize: NSFont.systemFontSize)
            label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.widthAnchor.constraint(equalToConstant: maxLabelWidth).isActive = true

            // Set the width of the view in the second column to the maximum view width
            view.translatesAutoresizingMaskIntoConstraints = false
            // view.widthAnchor.constraint(equalToConstant: maxViewWidth).isActive = true

            // Add label and view to the row
            rowStack.addArrangedSubview(label)
            rowStack.addArrangedSubview(view)

            container.addArrangedSubview(rowStack)
        }

        let centeringContainer = NSView()
        centeringContainer.addSubview(container)

        // Apply padding by setting constraints
        container.translatesAutoresizingMaskIntoConstraints = false
        container.leadingAnchor.constraint(equalTo: centeringContainer.leadingAnchor, constant: 20).isActive = true
        container.trailingAnchor.constraint(equalTo: centeringContainer.trailingAnchor, constant: -20).isActive = true
        container.topAnchor.constraint(equalTo: centeringContainer.topAnchor, constant: 20).isActive = true
        container.bottomAnchor.constraint(equalTo: centeringContainer.bottomAnchor, constant: -20).isActive = true

        return centeringContainer
    }

    func refresh() {
        for (_, view) in settingViewItems {
            if let refreshableView = view as? SettingsView {
                refreshableView.refresh()
            }
        }
        // self.window.orderOut(nil)
    }

    // Override this method to control window close behavior
    func windowShouldClose(_ sender: NSWindow) -> Bool {
        // Hide the window instead of closing it to avoid quitting the app
        sender.orderOut(nil)
        return false // Returning false prevents the window from actually closing
    }
}
