//
//  DeviceHelper.swift
//  XCInstaller
//
//  Created by VR on 23/01/21.
//  Copyright © 2021 VR. All rights reserved.
//

import Foundation
import Cocoa

enum DeviceError: Error {
    case serializationFailed
}

class DeviceHelper:NSObject {
    private var scriptName = "GetDevices"
    private var scriptType = "sh"
    private var scriptHandler:ShellCommandHandler?
    private var completionHandler: ((Result<Bool,Error>) -> Void)?
    private var deviceStore: DeviceDataStore
    
    init(_ store: DeviceDataStore) {
        self.deviceStore = store
        super.init()
    }
    
    func getScriptExecutablePath(_ name:String ,extension fileType: String ) -> String? {
         return Bundle.main.path(forResource: name, ofType: fileType)
     }
    
    func getSimulatorList() -> [Device] {
        if let devices = deviceStore.getSimulatorDevicesList() {
                return devices
        }
        else{
            return []
        }
    }
    
    func retrieveSimulatorListFromShell(_ completionHandler:((Result<Bool,Error>) -> Void)?) {
        guard let  executablePath = getScriptExecutablePath(scriptName, extension: scriptType) else {
            return
        }
        self.completionHandler = completionHandler
        let scriptHandler = ShellCommandHandler.getCommandHandler(path: executablePath, arguments:[], delegate: self)
        self.scriptHandler = scriptHandler
        scriptHandler.execute()
    }
    
    func parseDeviceListResponse(_ data:Data?) -> [String:AnyObject]? {
        guard let data = data else { return nil }
        
        do {
          return  try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject]
            
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
    
    func convertToDictionary(text: String) -> [String: AnyObject]? {
        if let data = text.data(using: .utf8) {
           
        }
        return nil
    }
}

extension DeviceHelper: ShellCommandDelegate {

    
    func shellCommandDidFinish(_ exitcode: Int, with handler: ShellCommandHandler) {
       self.completionHandler?(.success(true))
    }
    
    func shellCommandDidOutputData(_ response: Data, with handler: ShellCommandHandler) {
        if let responseDic = parseDeviceListResponse(response), let deviceDic = responseDic["devices"] as? [String: AnyObject] {
            var devicesToStore = [[String:AnyObject]]()
            for key in deviceDic.keys {
                if let simulatorListSinglePlatform = deviceDic[key] as? Array<Dictionary<String,AnyObject>> {
                    devicesToStore += simulatorListSinglePlatform
                }
            }
            if devicesToStore.isEmpty == false {
                self.deviceStore.saveSimulatorListToStore(devices: devicesToStore)
                self.completionHandler?(.success(true))
            }
            else{
                self.completionHandler?(.success(false))
            }
            
        }else {
            self.completionHandler?(.failure(DeviceError.serializationFailed))
        }
       
    }
    
    func shellCommandDidReceiveError(_ response: Data, with handler: ShellCommandHandler) {
         self.completionHandler?(.success(false))
    }
    
    
}

