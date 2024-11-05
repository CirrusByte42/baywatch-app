//
//  baywatch.swift
//  baywatch-app
//
//  Created by thibaut robinet on 12/03/2023.
//

import Foundation
import AppKit

func openTerminal(at url: URL?) {
    guard let url = url,
          let appUrl = NSWorkspace.shared.urlForApplication(withBundleIdentifier: getTerminalApplication())
    else { return }

    NSWorkspace.shared.open([url], withApplicationAt: appUrl, configuration: NSWorkspace.OpenConfiguration())
}

func openPathTerminalAndExecuteCommand(path: URL, command: String) {
    let terminalScript = """
    cd "\(path.relativePath)"
    direnv allow
    clear
    \(command)
    """

    if let url = NSWorkspace.shared.urlForApplication(withBundleIdentifier: getTerminalApplication()) {
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

func openDoc(client: String) {
    let clientDocUrl = getBrowserURL(client: client)
    openBrowser(at: clientDocUrl)
}
