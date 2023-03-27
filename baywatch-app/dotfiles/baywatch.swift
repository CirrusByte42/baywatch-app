//
//  baywatch.swift
//  baywatch-app
//
//  Created by thibaut robinet on 12/03/2023.
//

import Foundation
import AppKit

func getClientPath(client: String) -> URL {
    let dotfilesPath = getDotfilesPath()
    let clientPath = dotfilesPath.appendingPathComponent(client)
    return clientPath
}

func openTerminal(at url: URL?){
    guard let url = url,
          let appUrl = NSWorkspace.shared.urlForApplication(withBundleIdentifier: "com.apple.Terminal")
    else { return }
    
    NSWorkspace.shared.open([url], withApplicationAt: appUrl, configuration: NSWorkspace.OpenConfiguration())
}

func openClientTerminal(client: String){
    let clientPath = getClientPath(client: client)
    print("Client path = \(clientPath)")
    openTerminal(at: clientPath)
}

func openClientTerminalAndExecuteCommand(client: String, command : String){
    // Method 1
    let path = getClientPath(client: client)
    openPathTerminalAndExecuteCommand(path: path, command: command)
}

func openPathTerminalAndExecuteCommand(path: URL, command : String){
    let terminalScript = """
    cd "\(path.relativePath)"
    direnv allow
    clear
    \(command)
    """
    
    if let url = NSWorkspace.shared.urlForApplication(withBundleIdentifier: "com.apple.Terminal") {
        let configuration = NSWorkspace.OpenConfiguration()
        let doScriptEvent = NSAppleEventDescriptor(eventClass: kAECoreSuite,
                                                   eventID: kAEDoScript, targetDescriptor: nil, returnID: AEReturnID(kAutoGenerateReturnID),
                                                   transactionID: AETransactionID(kAnyTransactionID))
        doScriptEvent.setParam(NSAppleEventDescriptor(string: terminalScript), forKeyword:keyDirectObject)
        configuration.appleEvent = doScriptEvent
        NSWorkspace.shared.openApplication(at: url, configuration: configuration, completionHandler: { app, error in
            if error != nil {
                print("Error: \(String(describing: error))")
            }
        })
    }
}


func baywatchsetupInClientTerminal(client: String){
    openClientTerminalAndExecuteCommand(client: client, command: "baywatch setup")
}

func baywatchloginInClientTerminal(client: String){
    openClientTerminalAndExecuteCommand(client: client, command: "baywatch login")
}

func baywatchopenInClientTerminal(client: String){
    openClientTerminalAndExecuteCommand(client: client, command: "baywatch open")
}

func baywatchcheckInClientTerminal(client: String){
    openClientTerminalAndExecuteCommand(client: client, command: "baywatch check")
}
