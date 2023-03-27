//
//  setup.swift
//  baywatch-app
//
//  Created by thibaut robinet on 19/03/2023.
//

import Foundation
//import Cocoa
import SwiftUI


//---- GET PATHS--------------------------------------------
func getDotBaywatchPath() -> URL{
    let homeDir = FileManager.default.homeDirectoryForCurrentUser
    let dbw = ".baywatch/"
    let dotBaywatchUrl = homeDir.appendingPathComponent(dbw)
    return dotBaywatchUrl
}

//---- TEST SETUP--------------------------------------------
func isDotBaywatchExist() -> Bool{
    let url = getDotBaywatchPath().relativePath
    var dir: ObjCBool = true
    if FileManager.default.fileExists(atPath: url, isDirectory: &dir){
        return true
    }
    return false
}

func isConfigSetuped() -> Bool{
    let configPath = getConfigPath().relativePath
    var dir: ObjCBool = false
    if FileManager.default.fileExists(atPath: configPath, isDirectory: &dir){
        return true
    }
    return false
}

func isBaywatchDotfilesSetuped() -> Bool{
    let dotPath = getDotfilesPath().relativePath
    var dir: ObjCBool = true
    if FileManager.default.fileExists(atPath: dotPath, isDirectory: &dir){
        return true
    }
    return false
}

func isBaywatchCliInstalled() -> Bool{
    let homeDir = FileManager.default.homeDirectoryForCurrentUser
    let out = shell(path: homeDir, "ls /usr/local/bin | grep baywatch")
    if out.contains("baywatch"){
        return true
    }
    else{
        return false
    }
}

func isSetuped() -> Bool{
    print("Is ./baywatch exist : \(isDotBaywatchExist())")
    print("Is ./baywatch/config.yaml exist : \(isConfigSetuped())")
    print("Is ./baywatch/baywatch-dotfiles exist : \(isBaywatchDotfilesSetuped())")
    print("Is baywatch cli installed : \(isBaywatchCliInstalled())")
    if !isBaywatchCliInstalled(){
        alertBaywatchCli()
    }
    return isDotBaywatchExist() && isConfigSetuped() && isBaywatchDotfilesSetuped()
}
//---- CONFIG STEPS------------------------exist-------------------
func createDotBaywatch(){
    let dbwUrl = getDotBaywatchPath()
    try! FileManager.default.createDirectory(at: dbwUrl, withIntermediateDirectories: false)
}

func createConfig(){
    let defaultUserConfig : userConfig = defaultUserConfig()
    updateConfig(config: defaultUserConfig)
}

func cloneBaywatchDotfiles(){
    let command = "git clone git@github.com:padok-team/baywatch-dotfiles.git"
    let path = getDotBaywatchPath()
    if !isSshRequieredPassword(){
        // Clone the repo in background, you does not need to enter the password
        _ = shell(path: path, command)
    }
    else{
        print("Password is required")
        openPathTerminalAndExecuteCommand(path: path, command: command)
    }
}

func isSshRequieredPassword() -> Bool{
    let dbwUrl = FileManager.default.homeDirectoryForCurrentUser
    let output = shell(path: dbwUrl,"test $(ssh-keygen -y -P '' -f ~/.ssh/id_rsa >/dev/null 2>&1)$? -ne 0 && echo 1 || echo 0" )
    let result = output.dropLast(1)
    let intResult =  Int(result) ?? 1
    let boolResult = intResult != 0
    return boolResult
}

func alertBaywatchCli(){
    // Create an alert message popup
    let alert = NSAlert()
    alert.messageText = "Baywatch cli is not installed!"
    alert.informativeText = "The use of the application will be degraded."
    alert.addButton(withTitle: "How to install it ?")
    alert.addButton(withTitle: "Ok")
    alert.alertStyle = NSAlert.Style.warning
    let res = alert.runModal()
    if res == NSApplication.ModalResponse.alertFirstButtonReturn {
        // Open the baywatch repository
        let url = URL(string: "https://github.com/padok-team/baywatch")!
        NSWorkspace.shared.open(url)
    }
}

//---- MAIN SETUP --------------------------------------------
func setup(){
    if !isDotBaywatchExist(){
        createDotBaywatch()
    }
    if !isConfigSetuped(){
        createConfig()
    }
    if !isBaywatchDotfilesSetuped(){
        cloneBaywatchDotfiles()
    }
}
