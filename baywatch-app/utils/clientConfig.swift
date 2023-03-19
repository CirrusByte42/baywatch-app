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
    var oncall: Bool
    var run: Bool
}

func getClientConfigPath(client: String) -> URL{
    let homeDir = FileManager.default.homeDirectoryForCurrentUser
    let defaultPath = ".baywatch/baywatch-dotfiles/\(client)/.baywatch/config.yaml"
    let configUrl = homeDir.appendingPathComponent(defaultPath)

    print("ClientConfig Config URL = \(configUrl)")

    return configUrl
}
func isClientConfig(client: String) -> Bool{
    if readClientConfig(client: client) == nil{
        return false
    }
    return true
}
func readClientConfig(client: String) -> String? {
    var clientConfig = ""
    let configPath = getClientConfigPath(client: client)
    do {
        clientConfig = try String(contentsOf: configPath , encoding: .utf8)
    }
    catch {
        print("Read error :  \(client) config does not exist")
        return nil
    }
    return clientConfig
}

func getClientConfig(client: String) -> clientConfig{
    let stringClientConfig = readClientConfig(client: client)
    var myClientConfig : clientConfig = {clientConfig(name: client, oncall: false, run: true)}()
    
    // Deal with unexisting client config file
    if stringClientConfig == nil {
        return myClientConfig
    }
    let decoder = YAMLDecoder()
    do {
        myClientConfig = try decoder.decode(clientConfig.self, from: stringClientConfig!)
        print("[YAML] clientConfig", myClientConfig)
    }
    catch {
        /* handle if there are any errors */
        print("Get error :  \(error)")
    }
    return myClientConfig
}

func isRunner(client: clientConfig) -> Bool{
    return client.run
}

func isOnCall(client: clientConfig) -> Bool{
    return client.oncall
}

// Take the current user and allclients names and give the list of concerning clients
func filterClients(user: userConfig, clients: [String]) -> [String]{
    // Case where nothing to do
    if user.is_oncall && user.is_runner{
        return clients
    } else if !user.is_oncall && !user.is_runner{
        return []
    }
    var result: [String] = []
    var cliConfig : clientConfig
    for clientName in clients{
        cliConfig = getClientConfig(client: clientName)
        
        if user.is_oncall && cliConfig.oncall{
            result.append(clientName)
        } else if user.is_runner && cliConfig.run{
            result.append(clientName)
        }
    }
    return result
}

func needToHideClient(user: userConfig, client: String) -> Bool {
    // Case where nothing to do
    if user.is_oncall && user.is_runner{
        return false
    } else if !user.is_oncall && !user.is_runner{
        return true
    }
    let cliConfig = getClientConfig(client: client)
    
    if user.is_oncall && cliConfig.oncall{
        return false
    } else if user.is_runner && cliConfig.run{
        return false
    }
    return true
}
