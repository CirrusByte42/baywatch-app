////
////  Config.swift
////  baywatch-app
////
////  Created by thibaut robinet on 10/03/2023.
////
//
// import Foundation
// import Yams
//
// public let DEFAULT_USER_CONFIG_FILE_PATH = ".baywatch/config.yaml"
//
// public struct userConfig: Codable {
//    var baywatch_main_repository: String? // BAYWATCH_MAIN_REPOSITORY_PATH
// }
//
// func getConfigPath() -> URL {
//    let homeDir = FileManager.default.homeDirectoryForCurrentUser
//    let configUrl = homeDir.appendingPathComponent(".baywatch/config.yaml")
//    return configUrl
// }
//
// func writeUserConfig(userConfig: String) {
//    let configPath = getConfigPath()
//    do {
//        try! userConfig.write(to: configPath, atomically: true, encoding: String.Encoding.utf8)
//    }
// }
