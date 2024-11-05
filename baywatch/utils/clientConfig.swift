//
//  clientConfig.swift
//  baywatch-app
//
//  Created by thibaut robinet on 12/03/2023.
//

import Foundation
import Yams

public struct clientConfig: Codable {
    var name: String
}

func getClientConfigPath(client: String) -> URL {
    var baywatchdotfilesPath = getBaywatchDotfilesPath()
    if baywatchdotfilesPath == nil {
        let homeDir = FileManager.default.homeDirectoryForCurrentUser
        baywatchdotfilesPath = homeDir.appendingPathComponent(".baywatch/baywatch-dotfiles")
    }
    let defaultPath = "/\(client)/.baywatch/config.yaml"
    let configUrl = baywatchdotfilesPath!.appendingPathComponent(defaultPath)
    return configUrl
}

func getBrowserURL(client: String) -> String {
    let browserUrl = "https://github.com/padok-team/baywatch-dotfiles/tree/main/\(client)"
    return browserUrl
}

func isClientAsConfig(client: String) -> Bool {
    if readClientConfig(client: client) == nil {
        return false
    }
    return true
}

func readClientConfig(client: String) -> String? {
    var clientConfig = ""
    let configPath = getClientConfigPath(client: client)
    do {
        clientConfig = try String(contentsOf: configPath, encoding: .utf8)
    } catch {
        //        print("Read error :  \(client) config does not exist")
        return nil
    }
    return clientConfig
}

func getClientConfig(client: String) -> clientConfig {
    let stringClientConfig = readClientConfig(client: client)
    var myClientConfig: clientConfig = {clientConfig(name: client)}()

    // Deal with unexisting client config file
    if stringClientConfig == nil {
        return myClientConfig
    }
    let decoder = YAMLDecoder()
    do {
        myClientConfig = try decoder.decode(clientConfig.self, from: stringClientConfig!)
        print("[YAML] clientConfig", myClientConfig)
    } catch {
        /* handle if there are any errors */
        print("Get error :  \(error)")
    }
    return myClientConfig
}
