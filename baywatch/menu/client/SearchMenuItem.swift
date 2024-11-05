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

extension BaywatchMenu {
    func filterMenuItems(with query: String) {
        let q = query.lowercased()
        for item in self.items {
            if item.tag == menuTags.CLIENT.rawValue {
                let name = (item as! ClientMenuItem).Name.lowercased()
                if name.contains(q) || q == "" {
                    item.isHidden = false
                } else {
                    // We unselect item only if the filter unselected himself
                    if item.isHighlighted {
                        self.perform(NSSelectorFromString("highlightItem:"), with: nil)
                    }
                    item.isHidden = true
                }
            }
        }
        update()
    }
}
