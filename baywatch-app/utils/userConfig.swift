//
//  Config.swift
//  baywatch-app
//
//  Created by thibaut robinet on 10/03/2023.
//

import Foundation
import Yams


public struct userConfig: Codable {
    var is_oncall: Bool
    var is_runner: Bool
}


func getConfigPath() -> URL{
    let homeDir = FileManager.default.homeDirectoryForCurrentUser
    let defaultPath = ".baywatch/config.yaml"
    let configUrl = homeDir.appendingPathComponent(defaultPath)
    return configUrl
}

func readUserConfig() -> String {
    var userConfig = ""
    let configPath = getConfigPath()
    do {
        userConfig = try String(contentsOf: configPath , encoding: .utf8)
    }
    catch {
        print("error :  \(error)")
    }
    return userConfig
}

func getUserConfig() -> userConfig{
    let stringUserConfig = readUserConfig()
    var myUserConfig : userConfig = {userConfig(is_oncall: false, is_runner: false)}()
    
    let decoder = YAMLDecoder()
    do {
        myUserConfig = try decoder.decode(userConfig.self, from: stringUserConfig)
        print("[YAML] userConfig", myUserConfig.is_oncall)
    }
    catch {
        /* handle if there are any errors */
        print("error :  \(error)")
    }
    return myUserConfig
}

func writeUserConfig(userConfig : String) {
    let configPath = getConfigPath()
    do {
        try! userConfig.write(to: configPath, atomically: true, encoding: String.Encoding.utf8)
    }
}

func updateConfig(config: userConfig){
    // Encode to yaml
    let encoder = YAMLEncoder()
    do {
        let encodedYAML = try encoder.encode(config)
        writeUserConfig(userConfig: encodedYAML)
    }
    catch {
        print("error :  \(error)")
    }
}
