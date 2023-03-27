//
//  CloneMenu.swift
//  baywatch-app
//
//  Created by thibaut robinet on 25/03/2023.
//

import Foundation
import AppKit


class CloneMenuItem : GitMenuItem {
    let cloneTitle = "baywtach-dotfiles repository is not yet pull"
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init(appDelegate : AppDelegate) {
        super.init(title: self.cloneTitle, action: #selector(appDelegate.noAction) , keyEquivalent: "", appDelegate: appDelegate)
        self.state = NSControl.StateValue.off
        self.tag = menuTags.CLONE.rawValue
    }
    
    override func createSubmenu() {
        let subMenu = NSMenu()
        let clone = NSMenuItem(title: "Git clone", action: #selector(self.appDelegate!.gitClone) , keyEquivalent: "c")
        subMenu.addItem(clone)
        self.submenu = subMenu
    }
}

extension AppDelegate{
    @objc func gitClone() {
        print("Execute git clone")
        cloneBaywatchDotfiles()
    }
    //@objc func gitClone() {
    //    cloneBaywatchDotfiles()
    ////        refreshStatus()
    //    return
    //}
}


