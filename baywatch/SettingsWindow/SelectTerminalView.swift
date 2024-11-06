//
//  SelectTerminalView.swift
//  baywatch
//
//  Created by thibaut robinet on 04/11/2024.
//

import AppKit

// let termAppTitle = NSTextField(labelWithString:)
class SelectTerminalView: NSPopUpButton, SettingsView {
    init() {
        super.init(frame: NSRect(x: 0, y: 0, width: 100, height: 30), pullsDown: false)
        self.focusRingType = .exterior
        self.highlight(true)
        self.tag = 2
        // Build popmenu
        buildPopMenu()

        // Select the current Temrinal app configured
        self.refresh()
        self.target = self
        self.action = #selector(popupButtonSelectionChanged(_:))
    }

    func buildPopMenu() {
        let menu = NSMenu()

        // "Default" Section
        let defaultTitleItem = createNonSelectableMenuItem(title: "Default")
        menu.addItem(defaultTitleItem)
        menu.addItem(withTitle: "Terminal.app", action: nil, keyEquivalent: "")
        menu.addItem(NSMenuItem.separator())

        // "Applications" Section
        let applicationsTitleItem = createNonSelectableMenuItem(title: "Applications")
        menu.addItem(applicationsTitleItem)

        // Get the applications in the /Applications directory
        let fileManager = FileManager.default
        let appDirectory = "/Applications"
        if let appURLs = try? fileManager.contentsOfDirectory(atPath: appDirectory) {
            let sortedAppURLs = appURLs.sorted { $0.localizedCaseInsensitiveCompare($1) == .orderedAscending }
            for app in sortedAppURLs where app.hasSuffix(".app") {
                menu.addItem(withTitle: app, action: nil, keyEquivalent: "")
            }
        }
        // Set the menu for the popup button
        self.menu = menu
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func popupButtonSelectionChanged(_ sender: NSPopUpButton) {
        print("selected")
        if let selectedItem = sender.selectedItem {
            if selectedItem.title == "Terminal.app" {
                UserDefaults.standard.set("com.apple.Terminal", forKey: "termApplication")
                return
            }

            let appPath = "/Applications/"+selectedItem.title
            let appURL = URL(fileURLWithPath: appPath)

            if let bundle = Bundle(url: appURL) {
                UserDefaults.standard.set(bundle.bundleIdentifier, forKey: "termApplication")
                return
            }
        }
    }

    func refresh() {
        let termAppName = getTermApplicationName()
        self.selectItem(withTitle: termAppName)
    }
}

// Function to create a non-clickable and non-selectable menu item with custom styling
func createNonSelectableMenuItem(title: String) -> NSMenuItem {
    let menuItem = NSMenuItem(title: "", action: nil, keyEquivalent: "")

    // Create a custom view for the menu item to apply custom styling
    let customView = NSView(frame: NSRect(x: 0, y: 0, width: 200, height: 22))

    // Create a label with custom properties: gray color, smaller font, and top-left alignment
    let label = NSTextField(labelWithString: title)
    label.font = NSFont.systemFont(ofSize: 12)
    label.textColor = NSColor.gray
    label.isEditable = false
    label.isBordered = false
    label.backgroundColor = .clear
    label.alignment = .left
    label.frame = NSRect(x: 5, y: 0, width: 200, height: 22) // Positioned in the top-left corner

    // Add the label to the custom view
    customView.addSubview(label)

    // Assign the custom view to the menu item
    menuItem.view = customView

    return menuItem
}

func getTerminalApplication() -> String {
    var termApplication = "com.apple.Terminal"
    if UserDefaults.standard.object(forKey: "termApplication") != nil {
        termApplication = UserDefaults.standard.object(forKey: "termApplication") as! String
    }
    return termApplication
}

func getTermApplicationName() -> String {
    let termApplicationName = getFavoriteTermApplicationName()
    print("Term Application Name: \(termApplicationName!)")
    if termApplicationName == nil {
        return "Terminal.app"
    }
    return termApplicationName! + ".app"
}

func getFavoriteTermApplicationName() -> String? {
    let termApplicationBundle = getTerminalApplication()
    print("Favorite Term Application Bundle: \(termApplicationBundle)")
    let workspace = NSWorkspace.shared
    if let appURL = workspace.urlForApplication(withBundleIdentifier: termApplicationBundle) {
        return appURL.deletingPathExtension().lastPathComponent
    }
    return nil
}
