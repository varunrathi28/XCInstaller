//
//  Executable.swift
//  XCInstaller
//
//  Created by VR on 23/01/21.
//  Copyright © 2021 VR. All rights reserved.
//

import Foundation

protocol ShellExecutable {
    var scriptName:String { get }
    var scriptType:String { get }
    var shellTerminal: ShellCommandHandler { get }
    func getScriptExecutablePath() -> String
    
}
