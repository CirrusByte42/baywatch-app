////
////  setup.swift
////  baywatch-app
////
////  Created by thibaut robinet on 19/03/2023.
////
//
// import Foundation
//// import Cocoa
// import SwiftUI
//
// func getDefaultConfigFolder() -> URL {
//    let homeDir = FileManager.default.homeDirectoryForCurrentUser
//    let dbw = ".baywatch/"
//    let dotBaywatchUrl = homeDir.appendingPathComponent(dbw)
//    return dotBaywatchUrl
// }
//
// func isDefaultConfigFolderExist() -> Bool {
//    let url = getDefaultConfigFolder().relativePath
//    var dir: ObjCBool = true
//    if FileManager.default.fileExists(atPath: url, isDirectory: &dir) {
//        return true
//    }
//    return false
// }
//
// func isDefaultConfigFileExist() -> Bool {
//    let url = getDefaultConfigFolder().relativePath
//    var dir: ObjCBool = false
//    if FileManager.default.fileExists(atPath: url, isDirectory: &dir) {
//        return true
//    }
//    return false
// }
//
// func isBaywatchMainRepositoryExist(main_repository_path: String) -> Bool {
//    var dir: ObjCBool = true
//    if FileManager.default.fileExists(atPath: main_repository_path, isDirectory: &dir) {
//        return true
//    }
//    return false
// }
//
// func isBaywatchCliInstalled() -> Bool {
//    let homeDir = FileManager.default.homeDirectoryForCurrentUser
//    let out = shell(path: homeDir, "which baywatch | grep baywatch")
//    if out.contains("baywatch") {
//        return true
//    } else {
//        return false
//    }
// }
//
//// ---- CONFIG STEPS------------------------exist-------------------
// func createDefaultConfigFolder() {
//    let dbwUrl = getDefaultConfigFolder()
//    try! FileManager.default.createDirectory(at: dbwUrl, withIntermediateDirectories: false)
// }
//
// func createDefaultConfigFile() {
//    // let dbwUrl = getDefaultConfigFolder()
//    // try! FileManager.default.createDirectory(at: dbwUrl, withIntermediateDirectories: false)
//    print("TODO - Create a file by saving userConfig")
// }
//
// func cloneBaywatchDotfiles(path: URL) {
//    let command = "git clone git@github.com:padok-team/baywatch-dotfiles.git"
//    if !isSshRequieredPassword() {
//        // Clone the repo in background, you does not need to enter the password
//        _ = shell(path: path, command)
//    } else {
//        print("Password is required")
//        openPathTerminalAndExecuteCommand(path: path, command: command)
//    }
// }
//
// func isSshRequieredPassword() -> Bool {
//    let dbwUrl = FileManager.default.homeDirectoryForCurrentUser
//    let output = shell(path: dbwUrl, "test $(ssh-keygen -y -P '' -f ~/.ssh/id_rsa >/dev/null 2>&1)$? -ne 0 && echo 1 || echo 0" )
//    let result = output.dropLast(1)
//    let intResult =  Int(result) ?? 1
//    let boolResult = intResult != 0
//    return boolResult
// }
//
// func alertBaywatchCli() {
//    // Create an alert message popup
//    let alert = NSAlert()
//    alert.messageText = "Baywatch cli is not installed!"
//    alert.informativeText = "The use of the application will be degraded."
//    alert.addButton(withTitle: "How to install it ?")
//    alert.addButton(withTitle: "Ok")
//    alert.alertStyle = NSAlert.Style.warning
//    let res = alert.runModal()
//    if res == NSApplication.ModalResponse.alertFirstButtonReturn {
//        // Open the baywatch repository
//        let url = URL(string: "https://github.com/padok-team/baywatch")!
//        NSWorkspace.shared.open(url)
//    }
// }
//
//// ---- MAIN SETUP --------------------------------------------
// func bootstrap(main_repository_path: URL) {
//    if !isDefaultConfigFolderExist() {
//        createDefaultConfigFolder()
//    }
//    if !isDefaultConfigFileExist() {
//        createDefaultConfigFile()
//    }
//    if !isBaywatchMainRepositoryExist(main_repository_path: main_repository_path.relativePath) {
//        cloneBaywatchDotfiles(path: main_repository_path)
//    }
// }
