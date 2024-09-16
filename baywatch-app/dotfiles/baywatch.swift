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

func openTerminal(at url: URL?) {
    guard let url = url,
          let appUrl = NSWorkspace.shared.urlForApplication(withBundleIdentifier: "com.apple.Terminal")
    else { return }

    NSWorkspace.shared.open([url], withApplicationAt: appUrl, configuration: NSWorkspace.OpenConfiguration())
}

func openClientTerminalAndExecuteCommand(client: String, command: String) {
    // Method 1
    let path = getClientPath(client: client)
    openPathTerminalAndExecuteCommand(path: path, command: command)
}

func openPathTerminalAndExecuteCommand(path: URL, command: String) {
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
        doScriptEvent.setParam(NSAppleEventDescriptor(string: terminalScript), forKeyword: keyDirectObject)
        configuration.appleEvent = doScriptEvent
        NSWorkspace.shared.openApplication(at: url, configuration: configuration, completionHandler: { _, error in
            if error != nil {
                print("Error: \(String(describing: error))")
            }
        })
    }
}

func openVscode(at url: URL?) {
    guard let url = url,
          let appUrl = NSWorkspace.shared.urlForApplication(withBundleIdentifier: "com.microsoft.VSCode")
    else { return }

    NSWorkspace.shared.open([url], withApplicationAt: appUrl, configuration: NSWorkspace.OpenConfiguration())
}

func openBrowser(at stringUrl: String) {
    if let url = URL(string: stringUrl) {
        NSWorkspace.shared.open(url)
    }
}

func openClientVScode(client: String) {
    openVscode(at: getClientPath(client: client))
}

func openClientTerminal(client: String) {
    let clientPath = getClientPath(client: client)
    openTerminal(at: clientPath)
}

func openDoc(client: String) {
    let clientDocUrl = getBrowserURL(client: client)
    openBrowser(at: clientDocUrl)
}
