//
//  ClientSearchView.swift
//  baywatch
//
//  Created by thibaut robinet on 16/09/2024.
//

import Foundation
import AppKit
import Cocoa

class ClientSearchView: NSView, NSSearchFieldDelegate, NSControlTextEditingDelegate {

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

    func load() {
        if UserDefaults.standard.object(forKey: "lastSearch") != nil {
            searchField.stringValue = UserDefaults.standard.object(forKey: "lastSearch") as! String
            searchDelegate!.searchItemViewDidEdit( Notification(name: NSNotification.Name("NSTextFieldDidChangeNotification"), object: searchField, userInfo: nil))
        }
    }

    func controlTextDidChange(_ obj: Notification) {
        if obj.object is NSSearchField {
            searchDelegate!.searchItemViewDidEdit(obj)
            UserDefaults.standard.set(searchField.stringValue, forKey: "lastSearch")
        }
    }
    func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
        if commandSelector == #selector(NSResponder.insertNewline(_:)) {
            searchDelegate!.hitEnter()
            return true
        }
        return false // Let default behavior happen otherwise
    }
}
