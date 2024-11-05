//
//  AppDelegate.swift
//  baywatch-app
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
        //        setupGlobalShortcut()
        initShortcut()
    }

    @objc func performMenuShortcutAction() {
        // This function will be called when Command + L is pressed, even if app is in the background
        print("Command + L shortcut triggered from the menu!")
        // Add your custom action here
    }

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

    func isMenuVisible() -> Bool {
        var menu = statusItem.menu as! BaywatchMenu?
        return menu?.isVisible() ?? false
    }

    @objc func showMenu(_ sender: Any?) {
        if let button = statusItem.button {
            if let button = statusItem.button {
                button.performClick(nil)
            }
        }
    }

    func hideMenu() {
        if isMenuVisible() {
            statusItem.menu?.cancelTracking() // Stop tracking the menu, effectively hiding it
        }
    }

    func initShortcut() {
        KeyboardShortcuts.onKeyUp(for: .openShortcut) {[self] in
            self.performGlobalAction()
        }
    }

    func performGlobalAction() {
        if !isMenuVisible() {
            print("Global shortcut : Menu is not visible")
            self.showMenu(nil)
        } else {
            print("Global shortcut : Menu is visible")
            hideMenu()
        }
    }
}
//    func setupGlobalShortcut() {
//        requestAccessibilityPermissions()
//
//        // Listen for global key presses using NSEvent's global monitor
//        NSEvent.addGlobalMonitorForEvents(matching: .keyDown) { [weak self] event in
//            self?.handleGlobalKeyDownEvent(event)
//        }
//
//        // Optional: Local monitor to work while the app is focused
//        NSEvent.addLocalMonitorForEvents(matching: .keyDown) { [weak self] event in
//            self?.handleGlobalKeyDownEvent(event)
//            return event
//        }
//    }
//
//    func handleGlobalKeyDownEvent(_ event: NSEvent) {
//        print("Key pressed: \(event.charactersIgnoringModifiers ?? ""), KeyCode: \(event.keyCode), ModifierFlags: \(event.modifierFlags)")
//        // Check if the Command + Control + M keys are pressed
//        if event.modifierFlags.contains([.shift, .command]) && event.keyCode == kVK_Space {
//            self.showMenu(nil)
//        }
// }
//    func requestAccessibilityPermissions() {
//        let options: NSDictionary = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as NSString: true]
//        let accessEnabled = AXIsProcessTrustedWithOptions(options)
//
//        print(Bundle.main.bundleIdentifier! + ": \(options)")
//        if !accessEnabled {
//            // print the app budle identifier
//            //            print("The app needs accessibility permissions to capture global events. \(options)")
//        }
//    }
// }

//// To use logo asset
// extension NSImage.Name {
//    static let logo = NSImage.Name("logo")
//    static let logo_mini = NSImage.Name("StatusBarIconColored")
// }
