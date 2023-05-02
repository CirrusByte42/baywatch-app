//
//  ClientMenuItem.swift
//  baywatch-app
//
//  Created by thibaut robinet on 25/03/2023.
//

import Foundation
import AppKit


struct command {
    var title: String
    var action: Selector?
    var shortcut: String
    var showAlways: Bool
}


class ClientMenuItem : NSMenuItem {

    var appDelegate : AppDelegate?
    var Name : String = ""
    var baywatchDotfilesExist: Bool = false
    var asConfig : Bool = false
    
    let Commands : [command] = [
        {command(title: "Terminal", action: #selector(AppDelegate.newTerminal) , shortcut: "t", showAlways: true)}(),
        {command(title: "Setup"   , action: #selector(AppDelegate.setup)       , shortcut: "s", showAlways: false)}(),
        {command(title: "Login"   , action: #selector(AppDelegate.login)       , shortcut: "l", showAlways: false)}(),
        {command(title: "Open"    , action: #selector(AppDelegate.open)        , shortcut: "o", showAlways: false)}(),
        {command(title: "Check"   , action: #selector(AppDelegate.check)       , shortcut: "c", showAlways: false)}(),
    ]
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init(clientName: String, appDelegate : AppDelegate) {
        self.Name = clientName
        self.appDelegate = appDelegate
        self.asConfig = isClientAsConfig(client: clientName)
        
        super.init(title: self.Name, action: #selector(AppDelegate.noAction), keyEquivalent: "")
        
       
    
        self.tag = menuTags.CLIENT.rawValue
        createSubmenu()
    }
    
    func createSubmenu(){
        let submenu = NSMenu()
        
        // Create items
        for com in Commands{
            let action = self.asConfig || com.showAlways ? com.action : nil
            let item = NSMenuItem(title: com.title, action: action, keyEquivalent: com.shortcut)
            submenu.addItem(item)
        }
        self.submenu = submenu
    }
    
    func hide(user: userConfig){
        self.isHidden = needToHideClient(user: user, client: self.Name)
    }
    
    func onCheckStatusUnknown(){
        self.offStateImage = NSImage(named: NSImage.statusNoneName)// "⚪️"
    }
    
    func onCheckSucess(){
        self.offStateImage = NSImage(named: NSImage.statusAvailableName) //"🟢"
    }
    
    func onCheckFailed(){
        self.offStateImage = NSImage(named: NSImage.statusUnavailableName) // "🔴"
    }
    
//    TODO - Setup a file to save last_check status to print the good color
//    Usage example
//    let parentItem = item.parent as! ClientMenuItem
//    parentItem.onCheckFailed()
//    parentItem.onCheckSucess()
}

extension AppDelegate{
    @objc func newTerminal(item : NSMenuItem) {
        openClientTerminal(client: item.parent?.title ?? "")
    }
    @objc func setup(item : NSMenuItem) {
        baywatchsetupInClientTerminal(client: item.parent?.title ?? "")
    }
    @objc func login(item : NSMenuItem) {
        baywatchloginInClientTerminal(client: item.parent?.title ?? "")
    }
    @objc func open(item : NSMenuItem) {
        baywatchopenInClientTerminal(client: item.parent?.title ?? "")
    }
    @objc func check(item : NSMenuItem) {
        baywatchcheckInClientTerminal(client: item.parent?.title ?? "")
    }
}
