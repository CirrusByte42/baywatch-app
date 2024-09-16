//
//  SearchMenuItem.swift
//  baywatch-app
//
//  Created by thibaut robinet on 16/09/2024.
//

import Foundation
import AppKit

class SearchMenuItem: NSMenuItem {
    weak var delegate: SearchItemViewEditingDelegate?

    required init(coder: NSCoder) {
        super.init(coder: coder)
    }

    init(searchDelegate: SearchItemViewEditingDelegate, appDelegate: AppDelegate) {
        super.init(title: "Search", action: #selector(appDelegate.noAction), keyEquivalent: "")
        self.delegate = searchDelegate
        let searchView = SearchView(frame: NSRect(x: 0, y: 0, width: 300, height: 30), searchDelegate: self.delegate! ) // Specify size here
        self.view = searchView

    }
}
