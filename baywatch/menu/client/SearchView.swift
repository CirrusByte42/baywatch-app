//
//  SearchView.swift
//  baywatch-app
//
//  Created by thibaut robinet on 16/09/2024.
//

import Foundation
import AppKit
import Cocoa

class SearchView: NSView, NSSearchFieldDelegate {

    weak var delegate: NSSearchFieldDelegate?
    var searchDelegate: SearchItemViewEditingDelegate?

    private let searchField: NSSearchField = {
        let field = NSSearchField()
        field.placeholderString = "Search..."
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()

    init(frame frameRect: NSRect, searchDelegate: SearchItemViewEditingDelegate) {
        super.init(frame: frameRect)
        self.searchDelegate = searchDelegate
        setupSearchField()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSearchField()
    }

    private func setupSearchField() {
        searchField.delegate = self
        addSubview(searchField)

        let size = self.frame.size.width - 20
        NSLayoutConstraint.activate([
            searchField.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            searchField.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            searchField.widthAnchor.constraint(equalToConstant: size )
        ])
    }

    func controlTextDidChange(_ obj: Notification) {
        if obj.object is NSSearchField {
            searchDelegate!.searchItemViewDidEdit(obj)
        }
    }
}
