//
//  SelectBaywatchDotfilePathView.swift
//  baywatch
//
//  Created by thibaut robinet on 04/11/2024.

import AppKit

class SelectBaywatchDotfilePathView: NSStackView, SettingsView {

    var pathTextField: NSTextField?
    var editButton: NSButton?

    init() {
        // Init stack view
        super.init(frame: NSRect(x: 0, y: 0, width: 300, height: 20))
        self.orientation = .horizontal
        self.spacing = 10
        self.alignment = .centerY

        // Init textfield
        pathTextField = NSTextField(labelWithString: "")
        self.refresh()
        pathTextField!.frame = NSRect(x: 0, y: 0, width: 250, height: 20)
        pathTextField!.isEditable = false
        pathTextField!.isSelectable = false
        pathTextField!.isBordered = true
        pathTextField!.bezelStyle = .squareBezel
        self.addArrangedSubview(pathTextField!)

        // Init button
        editButton = NSButton(title: "Edit path", target: self, action: #selector(selectPathButton))
        editButton!.frame = NSRect(x: 0, y: 0, width: 50, height: 20)
        self.addArrangedSubview(editButton!)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func selectPathButton() {
        let dialog = NSOpenPanel()

        dialog.title = "Choose a directory"
        dialog.showsResizeIndicator = true
        dialog.showsHiddenFiles = false
        dialog.canChooseFiles = false
        dialog.canChooseDirectories = true
        dialog.allowsMultipleSelection = false

        if dialog.runModal() == NSApplication.ModalResponse.OK {
            if let result = dialog.url {
                // Path selection is successful, do something with the result
                let selectedPath = result.path
                UserDefaults.standard.set(selectedPath, forKey: "baywatchDotfilesPath")
                if let identifier = pathTextField {
                    // Update the text in the pathValue field
                    pathTextField!.stringValue = selectedPath
                }
            }
        } else {
            // User cancel action
            print("No path selected")
        }
    }

    func refresh() {
        let currentBaywatchDotfilesPath = getFavoriteBaywatchDotfilesPath()
        pathTextField!.stringValue = currentBaywatchDotfilesPath
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

func getDefaultDotfilesPath() -> URL {
    let homeDir = FileManager.default.homeDirectoryForCurrentUser
    let defaultPath = ".baywatch/baywatch-dotfiles/"
    let configUrl = homeDir.appendingPathComponent(defaultPath)
    return configUrl
}

func getFavoriteBaywatchDotfilesPath() -> String {
    if UserDefaults.standard.object(forKey: "baywatchDotfilesPath") == nil {
        return getDefaultDotfilesPath().path
    }
    return UserDefaults.standard.object(forKey: "baywatchDotfilesPath")! as! String
}
