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
    let defaultUserConfig : userConfig = {userConfig(is_oncall: false, is_runner: false)}()
    updateConfig(config: defaultUserConfig)
}

func cloneBaywatchDotfiles(){
    let dbwURL = getDotBaywatchPath()
    _ = shell(path: dbwURL, "git clone git@github.com:padok-team/baywatch-dotfiles.git")
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
