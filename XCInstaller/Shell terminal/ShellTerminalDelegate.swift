//
//  ShellTerminalDelegate.swift
//  XCInstaller
//
//  Created by VR on 23/01/21.
//  Copyright © 2021 VR. All rights reserved.
//

import Foundation

protocol ShellCommandDelegate: class {
    func shellCommandDidFinish(_ exitcode:Int, with handler: ShellCommandHandler)
    func shellCommandDidOutputData(_ response:Data, with handler: ShellCommandHandler)
    func shellCommandDidReceiveError(_ response:Data, with handler: ShellCommandHandler)
}
