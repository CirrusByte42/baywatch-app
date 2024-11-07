//
//  AppDelegate.swift
//  baywatch
//
//  Created by thibaut robinet on 09/03/2023.
//

import Cocoa
import KeyboardShortcuts

class AppDelegate: NSObject, NSApplicationDelegate {

    var statusItem: NSStatusItem!
    var window: NSWindow!

    // SettingsWindow.sfiwft object must be declare here
    var settingViewItems = [] as [(String, NSView)]

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Create the StatusBarItem and set the logo
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        updateStatusBarImage()

        // Register to listen for updates from the settings window
        NotificationCenter.default.addObserver(self, selector: #selector(updateStatusBarImage), name: Notification.Name("UpdateStatusBarIcon"), object: nil)

        // Create the MenuBar
        let menu = BaywatchMenu()
        menu.initMenu(appDelegate: self)
        statusItem.menu = menu

        // Register global shortcut
        initGlobalShortcuts()
    }

    // This function is used to change the Top bar Icon
    @objc func updateStatusBarImage() {
        if let button = self.statusItem.button {

            // Retrieve user choice
            var checkboxState: Bool = false
            if UserDefaults.standard.object(forKey: "coloredTopBarIcon") != nil {
                checkboxState = UserDefaults.standard.object(forKey: "coloredTopBarIcon") as! Bool
            }
            // Update image
            var imageName: String = "StatusBarIcon"
            if checkboxState {
                imageName = "StatusBarIconColored"
            }
            let logoIcon = NSImage(named: NSImage.Name(imageName))
            button.image = logoIcon
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Clean up before the application exits
    }

    // Following functions are usefull to hide and show the top Bar menu
    func initGlobalShortcuts() {
        KeyboardShortcuts.onKeyUp(for: .openShortcut) {[self] in
            self.performGlobalAction()
        }
    }

    func isTopBarMenuVisible() -> Bool {
        let menu = statusItem.menu as! BaywatchMenu?
        return menu?.isVisible() ?? false
    }

    func showTopBarMenu(_ sender: Any?) {
        if statusItem.button != nil {
            if let button = statusItem.button {
                button.performClick(nil)
            }
        }
    }

    func hideTopBarMenu() {
        if isTopBarMenuVisible() {
            statusItem.menu?.cancelTracking() // Stop tracking the menu, effectively hiding it
        }
    }

    func performGlobalAction() {
        if !isTopBarMenuVisible() {
            print("Global shortcut triggered: TopBarMenu is now visible")
            self.showTopBarMenu(nil)
        } else {
            print("Global shortcut triggered: Menu is now hidden")
            hideTopBarMenu()
        }
    }
}
