//
//  ClientMenuItem.swift
//  baywatch
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

let SYNOPSIS_WEBHOOK = "https://n8n.services.container.padok.cloud/webhook/synopsis"
let HEALTHCHECK_WEBHOOK = "https://n8n.services.container.padok.cloud/webhook/healthcheck"

class ClientMenuItem: NSMenuItem {

    var appDelegate: AppDelegate?
    var Name: String = ""
    var baywatchDotfilesExist: Bool = false
    var asConfig: Bool = false

    let Commands: [command] = [
        {command(title: "Terminal", action: #selector(AppDelegate.terminal), shortcut: "", showAlways: true)}(),
        {command(title: "VSCode", action: #selector(AppDelegate.code), shortcut: "", showAlways: true)}(),
        {command(title: "Context", action: #selector(AppDelegate.context), shortcut: "", showAlways: true)}(),
        {command(title: "Datadog", action: #selector(AppDelegate.datadog), shortcut: "", showAlways: true)}(),
        {command(title: "Slack", action: #selector(AppDelegate.slack), shortcut: "", showAlways: true)}(),
        {command(title: "Jira", action: #selector(AppDelegate.jira), shortcut: "", showAlways: true)}(),
        {command(title: "JiraSynopsis", action: #selector(AppDelegate.explainJira), shortcut: "", showAlways: true)}(),
        {command(title: "Healthcheck", action: #selector(AppDelegate.healthcheck), shortcut: "", showAlways: true)}(),
        {command(title: "HealthcheckCreate", action: #selector(AppDelegate.healthcheckCreate), shortcut: "", showAlways: true)}()

    ]

    required init(coder: NSCoder) {
        super.init(coder: coder)
    }

    init(clientName: String, appDelegate: AppDelegate) {
        self.Name = clientName
        self.appDelegate = appDelegate
        self.asConfig = isClientAsConfig(client: clientName)

        super.init(title: self.Name, action: nil, keyEquivalent: "")

        if !self.asConfig {
            self.onNoBaywatchConfig()
        }
        self.tag = menuTags.CLIENT.rawValue
        createSubmenu()
    }

    func createSubmenu() {
        let submenu = NSMenu()

        // Create items
        for com in Commands {
            let action = self.asConfig || com.showAlways ? com.action : nil
            let item = NSMenuItem(title: com.title, action: action, keyEquivalent: com.shortcut)
            item.target = appDelegate
            item.representedObject = self
            submenu.addItem(item)
        }
        self.submenu = submenu
    }

    func onNoBaywatchConfig() {
        self.offStateImage = NSImage(named: NSImage.statusUnavailableName) // "🔴"
    }
}

extension AppDelegate {
    @objc func terminal(item: NSMenuItem) {
        let clientPath = getClientPath(client: item.parent?.title ?? "")
        openTerminal(at: clientPath)
    }
    @objc func code(item: NSMenuItem) {
        openVscode(at: getClientPath(client: item.parent?.title ?? ""))
    }
    @objc func doc(item: NSMenuItem) {
        openDoc(client: item.parent?.title ?? "")
    }
    @objc func context(item: NSMenuItem) {
        let cfg = getClientConfig(client: item.parent?.title ?? "")
        if cfg.context != nil {
            openBrowser(at: cfg.context!)
        } else {
            notConfiguredMessage(client: item.parent?.title ?? "unknown", param: "context")
        }
    }
    @objc func datadog(item: NSMenuItem) {
        let cfg = getClientConfig(client: item.parent?.title ?? "")
        if cfg.butsudan != nil {
            openBrowser(at: cfg.butsudan!)
        } else {
            notConfiguredMessage(client: item.parent?.title ?? "unknown", param: "budsudan")
        }

    }
    @objc func slack(item: NSMenuItem) {
        let cfg = getClientConfig(client: item.parent?.title ?? "")
        if cfg.slack != nil {
            openBrowser(at: cfg.slack!)
        } else {
            notConfiguredMessage(client: item.parent?.title ?? "unknown", param: "slack")
        }

    }
    @objc func jira(item: NSMenuItem) {
        let cfg = getClientConfig(client: item.parent?.title ?? "")
        if cfg.jira != nil && cfg.jira!.url != "" {
            openBrowser(at: cfg.jira!.url)
        } else {
            notConfiguredMessage(client: item.parent?.title ?? "unknown", param: "jira")
        }
    }
    @objc func explainJira(item: NSMenuItem) {
        let cfg = getClientConfig(client: item.parent?.title ?? "")
        if cfg.jira != nil && cfg.jira?.orgname != "" {
            let orgname = cfg.jira?.orgname
            let webhookURL = URL(string: SYNOPSIS_WEBHOOK)!
            var request = URLRequest(url: webhookURL)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue(orgname, forHTTPHeaderField: "ClientName")
            request.httpBody = "{}".data(using: .utf8)

            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Explain CallWebhook failed to send request: \(error)")
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("Explain CallWebhook: invalid response")
                    return
                }
                guard let data = data else {
                    print("Explain CallWebhook: no data received")
                    return
                }
                if httpResponse.statusCode >= 300 {
                    print("Explain CallWebhook: received non-2xx response: \(httpResponse.statusCode), Body: \(String(data: data, encoding: .utf8) ?? "")")
                } else {
                    openBrowser(at: String(data: data, encoding: .utf8)!)
                }
            }
            task.resume()
        } else {
            notConfiguredMessage(client: item.parent?.title ?? "unknown", param: "jira.orgname")
        }
    }
    @objc func healthcheck(item: NSMenuItem) {
        let cfg = getClientConfig(client: item.parent?.title ?? "")
        if cfg.healthcheck != nil && cfg.healthcheck!.drive_folder_url != "" {
            openBrowser(at: cfg.healthcheck!.drive_folder_url)
        } else {
            notConfiguredMessage(client: item.parent?.title ?? "unknown", param: "healtcheck")
        }
    }

    @objc func healthcheckCreate(item: NSMenuItem) {
        let cfg = getClientConfig(client: item.parent?.title ?? "")
        if cfg.healthcheck != nil && cfg.healthcheck!.drive_folder_url != "" && cfg.healthcheck?.language != "" && cfg.jira != nil && cfg.jira?.orgname != "" {
            callHealthcheckWebhook(cfg: cfg, clientName: item.parent?.title ?? "unknown")
        } else {
            notConfiguredMessage(client: item.parent?.title ?? "unknown", param: "healtcheck create")
        }
    }
}

func callHealthcheckWebhook(cfg: clientConfig, clientName: String) {
    let payload = "{}".data(using: .utf8)!
    let id = 0
    guard let url = URL(string: HEALTHCHECK_WEBHOOK) else {
        print("Invalid HEALTHCHECK_WEBHOOK URL")
        return
    }

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue(clientName, forHTTPHeaderField: "HealthcheckClient")
    request.setValue(String(id), forHTTPHeaderField: "HealthcheckID")
    request.setValue(cfg.healthcheck?.drive_folder_url, forHTTPHeaderField: "HealthcheckFolder")
    request.setValue(cfg.healthcheck?.language, forHTTPHeaderField: "HealthcheckLanguage")
    request.setValue(cfg.jira?.orgname, forHTTPHeaderField: "JiraOrgName")
    request.setValue(cfg.butsudan, forHTTPHeaderField: "DatadogUrl")
    request.httpBody = payload

    let semaphore = DispatchSemaphore(value: 0)
    var resultUrl = ""

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        defer { semaphore.signal() }

        if let error = error {
            print("Healthcheck CallWebhook failed to send request: \(error)")
            return
        }
        guard let httpResponse = response as? HTTPURLResponse else {
            print("Healthcheck CallWebhook: invalid response")
            return
        }
        guard let data = data else {
            print("Healthcheck CallWebhook: no data received")
            return
        }
        if httpResponse.statusCode >= 300 {
            print("Healthcheck CallWebhook: received non-2xx response: \(httpResponse.statusCode), Body: \(String(data: data, encoding: .utf8) ?? "")")
            return
        }
        let bodyString = String(data: data, encoding: .utf8) ?? ""
        print("🏭  Find your Healthcheck n°\(id) slides here: https://docs.google.com/presentation/d/\(bodyString)")
        resultUrl = "https://docs.google.com/presentation/d/\(bodyString)"
        openBrowser(at: resultUrl)
    }
    task.resume()
    semaphore.wait()
}

func notConfiguredMessage(client: String, param: String) {
    DispatchQueue.main.async {
        let alert = NSAlert()
        alert.messageText = "Not Available for \(client)"
        alert.informativeText = "Config doesn't contain \(param) URL."
        alert.alertStyle = .warning
        alert.addButton(withTitle: "OK")
        alert.runModal()
    }
}

extension BaywatchMenu {
    func buildClientMenu() {
        if baywatchDotfilesExist {
            if self.clientNames.count > 0 {
                for client in self.clientNames {
                    let clientItem = ClientMenuItem(clientName: client, appDelegate: self.appDelegate!)
                    self.addItem(clientItem)
                }
                self.addItem(NSMenuItem.separator())
            }
        }
        self.addItem(NSMenuItem.separator())
    }
}

func getClientPath(client: String) -> URL {
    var baywatchdotfilesPath = getBaywatchDotfilesPath()
    if baywatchdotfilesPath == nil {
        let homeDir = FileManager.default.homeDirectoryForCurrentUser
        baywatchdotfilesPath = homeDir.appendingPathComponent(".baywatch/baywatch-dotfiles")
    }
    let defaultPath = "/\(client)"
    let configUrl = baywatchdotfilesPath!.appendingPathComponent(defaultPath)
    return configUrl
}
