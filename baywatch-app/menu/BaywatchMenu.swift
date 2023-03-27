//
//  MyMenu.swift
//  baywatch-app
//
//  Created by thibaut robinet on 25/03/2023.
//

import Foundation
import AppKit

enum menuTags: Int {
    case CLIENT = 1
    case SWITCH = 2
    case STATUS = 3
    case CLONE  = 4
}

class BaywatchMenu: NSMenu, NSMenuDelegate{
    
    var clientNames : [String] = []
    var currentUserConfig : userConfig = defaultUserConfig()
    var baywatchDotfilesExist : Bool = false
    var appDelegate : AppDelegate?
    
    func initMenu(appDelegate: AppDelegate){
        self.appDelegate = appDelegate
        self.delegate = self as NSMenuDelegate
        self.loadData()
        self.build()
    }
    
    private func loadData(){
        // Load user config:
        currentUserConfig = getUserConfig()
        
        // Check if dotfiles folder exist
        baywatchDotfilesExist = isBaywatchDotfilesSetuped()
        
        // Load client Names
        if baywatchDotfilesExist{
            clientNames = clientList().sorted()
        }
    }
    
    func reloadData(){
        let bde = isBaywatchDotfilesSetuped()
        if self.baywatchDotfilesExist != bde{
            self.refresh()
        } else{
            self.updateStatus()
        }
    }

    func build(){
        self.buildGitMenu()
        
        self.buildSwitchs()
        
        self.buildClientMenu()
        self.hideClients()
        
        self.addItem(NSMenuItem.separator())
        // Add refresh button
        self.addItem(NSMenuItem(title: "Refresh", action: #selector(AppDelegate.refreshMenu), keyEquivalent: "r"))
        // Add quit button
        self.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
    }
        
    func buildGitMenu(){
        // Add status menu item
        let gitMenu : GitMenuItem
        if baywatchDotfilesExist{
            gitMenu = StatusMenuItem(appDelegate: self.appDelegate!)
        }else{
            gitMenu = CloneMenuItem(appDelegate: self.appDelegate!)
        }
        self.addItem(gitMenu)
        self.addItem(NSMenuItem.separator())
    }
    
    func buildSwitchs(){
        // Build Runner Switch
        let runner = SwitchMenuItem(switchText: SwitchNames.RUNNER, appDelegate: appDelegate!, initalValue: currentUserConfig.is_runner)
        self.addItem(runner)
        // Build Oncall Switch
        let oncall = SwitchMenuItem(switchText: SwitchNames.ONCALL, appDelegate: appDelegate!, initalValue: currentUserConfig.is_oncall)
        self.addItem(oncall)
        self.addItem(NSMenuItem.separator())
    }
    
    func buildClientMenu(){
        if baywatchDotfilesExist{
            if self.clientNames.count > 0{
                for client in self.clientNames{
                    let clientItem = ClientMenuItem(clientName: client, appDelegate: self.appDelegate!)
                    self.addItem(clientItem)
                }
                self.addItem(NSMenuItem.separator())
            }
        }
    }
    
    func clean(){
        self.items.removeAll(keepingCapacity: true)
    }
    
    func refresh(){
        loadData()
        clean()
        build()
    }
    func updateStatus(){
        for item in self.items{
            if item.tag == menuTags.STATUS.rawValue{
                Task {
                    await (item as! StatusMenuItem).update()
                }
            }
        }
    }
    
    func hideClients(){
        for item in self.items{
            if item.tag == menuTags.CLIENT.rawValue{
                (item as! ClientMenuItem).hide(user: currentUserConfig)
            }
        }
    }
    
    func menuNeedsUpdate(_ menu: NSMenu) {
        reloadData()
    }
    func menuWillOpen(_ menu: NSMenu){
        print("open")
    }
    func menuDidClose(_ menu: NSMenu) {
        print("close")
    }
}

extension AppDelegate{
    @objc func refreshMenu() {
        let menu = self.statusItem.menu as! BaywatchMenu
        menu.refresh()
    }
}
