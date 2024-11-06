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

func shell(path: URL, _ command: String) -> String {
    let task = Process()
    let pipe = Pipe()

    task.currentDirectoryURL = path
    task.standardOutput = pipe
    task.standardError = pipe
    task.arguments = ["-c", command]
    task.launchPath = "/bin/zsh"
    task.standardInput = nil
    task.launch()

    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output = String(data: data, encoding: .utf8)!

    return output
}
