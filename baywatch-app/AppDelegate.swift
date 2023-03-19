//
//  AppDelegate.swift
//  baywatch-app
//
//  Created by thibaut robinet on 09/03/2023.
//

import Cocoa
import SwiftUI

// To use logo asset
extension NSImage.Name {
    static let logo = NSImage.Name("logo")
    static let logo_mini = NSImage.Name("logo_mini")
}
// Menu bar example
class AppDelegate: NSObject, NSApplicationDelegate {
    
    private var statusItem: NSStatusItem!
    private var window: NSWindow!
    
    struct SwiftUIView: View {
        var body: some View {
            let logoIcon = NSImage(named: NSImage.Name("logo"))
            Text("Hello, SwiftUI!")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            Image(nsImage: logoIcon!)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // First of all, check the setup
        if !isSetuped(){
            baywatch_app.setup()
        }
        
        // Create the Menu Bar with logo
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let button = statusItem.button {
            let logoIcon = NSImage(named: NSImage.Name("logo_mini"))
            button.image = logoIcon
        }
                
        // Edit status Menu
        let clientsNames = clientList().sorted()
        statusItem.menu = createMenu(app: self, titles: clientsNames)
    }
    
    func refreshMenu(){
        let myUserConfig = getUserConfig()
        for item in statusItem.menu!.items{
            if item.tag == 1{
                item.isHidden = needToHideClient(user: myUserConfig, client: item.title)
            }
        }
    }
    func refreshStatus(){
        let uptodate = isUpToDate()
        for item in statusItem.menu!.items{
            if item.tag == 2{
                item.state = (uptodate) ? NSControl.StateValue.on : NSControl.StateValue.off
                let pull = item.submenu?.items[0]
                if uptodate{
                    pull!.action = nil
                } else{
                    pull!.action =  #selector(gitPull)
                }
            }
        }
    }
}


