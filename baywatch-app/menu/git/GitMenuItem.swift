//
//  GitMenu.swift
//  baywatch-app
//
//  Created by thibaut robinet on 25/03/2023.
//

import Foundation
import AppKit


class GitMenuItem : NSMenuItem {
    var baywatchDotfilesExist: Bool = false
    var appDelegate : AppDelegate?
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init(title: String, action selector: Selector?, keyEquivalent charCode: String, appDelegate : AppDelegate) {
        super.init(title: title, action: selector, keyEquivalent: charCode)
        self.appDelegate = appDelegate
        self.onStateImage = NSImage(named: NSImage.statusAvailableName) //"🟢"
        self.offStateImage = NSImage(named: NSImage.statusUnavailableName) // "🔴"
        self.isEnabled = false
        
        createSubmenu()
    }
    
    func createSubmenu(){
        return
    }
}
extension AppDelegate{
    @objc func noAction() {
        // Do nothing
        return
    }
}
