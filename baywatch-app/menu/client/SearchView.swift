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

    // Create the search field
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
        // Add the search field to the view
        // Add the search field and set the delegate
        searchField.delegate = self
        addSubview(searchField)

        // Set up Auto Layout constraints
        NSLayoutConstraint.activate([
            searchField.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            searchField.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            searchField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            searchField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5)
        ])
    }
    func controlTextDidChange(_ obj: Notification) {
        if let searchField = obj.object as? NSSearchField {
            searchDelegate!.searchItemViewDidEdit(obj)
        }
    }
}
