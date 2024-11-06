//
//  EnableColoredTopBarIconView.swift
//  baywatch
//
//  Created by thibaut robinet on 04/11/2024.
//

import AppKit

class EnableColoredTopBarIconView: NSButton, SettingsView {

    var checkboxState: Bool = false

    init() {
        super.init(frame: NSRect(x: 10, y: 120, width: 200, height: 20))
        self.title = "Colored"
        self.target = self
        self.action = #selector(checkboxToggled(_:))
        self.setButtonType(.switch)
        self.refresh()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func checkboxToggled(_ sender: NSButton) {
        if sender.state == .on {
            print("Checkbox is checked")
            UserDefaults.standard.set(true, forKey: "coloredTopBarIcon")
        } else {
            print("Checkbox is unchecked")
            UserDefaults.standard.set(false, forKey: "coloredTopBarIcon")
        }
        NotificationCenter.default.post(name: Notification.Name("UpdateStatusBarIcon"), object: nil)
    }

    func refresh() {
        if UserDefaults.standard.object(forKey: "coloredTopBarIcon") != nil {
            checkboxState = UserDefaults.standard.object(forKey: "coloredTopBarIcon") as! Bool
        } else {
            checkboxState = false
        }
        self.state = checkboxState ? .on : .off
        NotificationCenter.default.post(name: Notification.Name("UpdateStatusBarIcon"), object: nil)
    }
}
