//
//  dotfiles.swift
//  baywatch-app
//
//  Created by thibaut robinet on 10/03/2023.
//

import Foundation

extension URL {
    var isDirectory: Bool {
       (try? resourceValues(forKeys: [.isDirectoryKey]))?.isDirectory == true
    }
}

let exceptions : [String] = [".git","common",".tmpl","bin"]

// Create client structs and usefull functions

func getDotfilesPath() -> URL{
    let homeDir = FileManager.default.homeDirectoryForCurrentUser
    let defaultPath = ".baywatch/baywatch-dotfiles/"
    let configUrl = homeDir.appendingPathComponent(defaultPath)
    return configUrl
}


func clientList() -> [String] {
    var clientList : [String] = []
    let fm = FileManager.default
    let dotPath = getDotfilesPath()
    print("List folders \(dotPath) \(dotPath.absoluteString)")
    do {
        let items = try fm.contentsOfDirectory(at: dotPath, includingPropertiesForKeys: nil)

        for item in items {
            if item.isDirectory {
//                print("Found \(item.lastPathComponent)")
                clientList.append(item.lastPathComponent)
            }
        }
        for k in 0...exceptions.count - 1 {
            clientList = clientList.filter { $0 != exceptions[k] }
        }
    } catch {
        print("Error \(error)")
    }
    return clientList
}

func getHeadCurrentSha() -> String{
    let sha = shell("git rev-parse HEAD")
    return sha
}

func getLatestRemoteSha() -> String{
    // Update remote repository
    _ = shell("git fetch origin")
    // Get the latest sha
    let sha = shell("git rev-parse origin/main")
    return sha
}

func isUpToDate() -> Bool {
    let currentSha = getHeadCurrentSha()
    let lastSha = getLatestRemoteSha()
    if currentSha == lastSha{
        return true
    }
    return false
}

func shell(_ command: String) -> String {
    let path = getDotfilesPath()
    return shell(path: path, command)
}

func shell(path: URL,_ command: String) -> String {
    let task = Process()
    let pipe = Pipe()
    
    task.currentDirectoryURL = path
    task.standardOutput = pipe
    task.standardError = pipe
    task.arguments = ["-c",command]
    task.launchPath = "/bin/zsh"
    task.standardInput = nil
    task.launch()
    
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output = String(data: data, encoding: .utf8)!
    
    return output
}

