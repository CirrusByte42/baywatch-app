//
//  KeyboardShortcuts+Global.swift
//  baywatch
//
//  Created by thibaut robinet on 30/10/2024.
//

import Foundation
import KeyboardShortcuts

extension KeyboardShortcuts.Name {
    static let openShortcut = Self("openShortcut",
                                   default: .init(.l, modifiers: [.command]))
}
