////
////  User.swift
////  baywatch-app
////
////  Created by thibaut robinet on 17/09/2024.
////
//
// import Foundation
// import Yams
//
// class BaywatchUser {
//
//    var baywatch_config_path: URL?
//    var baywatch_main_repository: URL?
//
//    init() {
//        self.baywatch_config_path = getConfigPath()
//        self.read()
//    }
//
//    init(user: userConfig) {
//        self.baywatch_config_path = getConfigPath()
//        self.load(user: user)
//    }
//
//    func editMainRepository(newPath: String) {
//        self.baywatch_main_repository = URL(string: newPath)!
//        self.save()
//    }
//
//    func save() {
//        let user = userConfig(baywatch_main_repository: self.baywatch_main_repository?.relativePath)
//        let encoder = YAMLEncoder()
//        do {
//            let encodedYAML = try encoder.encode(user)
//            do {
//                try encodedYAML.write(to: self.baywatch_config_path!, atomically: true, encoding: String.Encoding.utf8)
//            }
//        } catch {
//            print("error :  \(error)")
//        }
//    }
//
//    func read() {
//        var user = ""
//        let configPath = getConfigPath()
//        do {
//            user = try String(contentsOf: configPath, encoding: .utf8)
//            let decoder = YAMLDecoder()
//            do {
//                let newUserConfig = try decoder.decode(userConfig.self, from: user)
//                self.load(user: newUserConfig)
//            } catch {
//                print("Error while reading user:  \(error) => defaultUserConfig returned")
//            }
//        } catch {
//            print("error :  \(error)")
//        }
//    }
//
//    func load(user: userConfig) {
//        if user.baywatch_main_repository == nil {
//            self.baywatch_main_repository = getDefaultDotfilesPath()
//        } else {
//            self.baywatch_main_repository = URL(string: user.baywatch_main_repository!)!
//        }
//    }
//
//    func isReady() -> Bool {
//        print("DefaultConfigFolder : \(getDefaultConfigFolder())")
//        print("Is ./baywatch exist : \(isDefaultConfigFolderExist())")
//        print("Is ./baywatch/config.yaml exist : \(isDefaultConfigFileExist())")
//        print("Is ./baywatch/baywatch-dotfiles exist : \(isBaywatchMainRepositoryExist(main_repository_path: self.baywatch_main_repository!.relativePath))")
//        print("Is baywatch cli installed : \(isBaywatchCliInstalled())")
//        if !isBaywatchCliInstalled() {
//            alertBaywatchCli()
//        }
//        return isDefaultConfigFolderExist() && isDefaultConfigFileExist() && isBaywatchMainRepositoryExist(main_repository_path: self.baywatch_main_repository!.relativePath)
//    }
//
//    func clientList() -> [String] {
//        var clientList: [String] = []
//        // Avoid trying to fetch client if the repo is not clone yet
//        if !self.isReady() {
//            return clientList
//        }
//
//        // Fetching client names
//        let fm = FileManager.default
//        do {
//            let items = try fm.contentsOfDirectory(at: self.baywatch_main_repository!, includingPropertiesForKeys: nil)
//
//            for item in items {
//                if item.isDirectory {
//                    clientList.append(item.lastPathComponent)
//                }
//            }
//            for k in 0...exceptions.count - 1 {
//                clientList = clientList.filter { $0 != exceptions[k] }
//            }
//        } catch {
//            print("Error fetching clients \(error)")
//            return clientList
//        }
//        return clientList
//    }
//
//    func getClientPath(client: String) -> URL {
//        let dotfilesPath = self.baywatch_main_repository!
//        let clientPath = dotfilesPath.appendingPathComponent(client)
//        return clientPath
//    }
//
