//
//  DeviceBootHelper.swift
//  XCInstaller
//
//  Created by VR on 23/01/21.
//  Copyright © 2021 VR. All rights reserved.
//

import Foundation

class DeviceBootHelper: NSObject {
    
    private var scriptName = "BootDevices"
    private var scriptType = "sh"
    private var scriptHandler:ShellCommandHandler?
    
    
    func getScriptExecutablePath() -> String? {
        let path =  Bundle.main.path(forResource: scriptName, ofType: scriptType)
        return path
    }
    
    func bootDevices(_ deviceUdidList:[String]){
        guard let path = getScriptExecutablePath() else { return }
        let shellHandler = ShellCommandHandler.getCommandHandler(path: path, arguments:deviceUdidList, delegate: self)
        self.scriptHandler = shellHandler
        shellHandler.execute()
    }
}

extension DeviceBootHelper : ShellCommandDelegate {
    func shellCommandDidFinish(_ exitcode: Int, with handler: ShellCommandHandler) {
        
    }
    
    func shellCommandDidOutputData(_ response: Data, with handler: ShellCommandHandler) {
        
    }
    
    func shellCommandDidReceiveError(_ response: Data, with handler: ShellCommandHandler) {
        
    }
    
    
}
