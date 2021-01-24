//
//  ViewController.swift
//  XCInstaller
//
//  Created by VR on 23/01/21.
//  Copyright © 2021 VR. All rights reserved.
//

import Cocoa
import AppKit

class InstallViewController: NSViewController {
    
    @IBOutlet var comboBoxSimulator: NSComboBox!
    @IBOutlet var popUpAppPath: NSPopUpButton!
    @IBOutlet var btnInstall: NSButton!
    var deviceHelper:DeviceHelper = DeviceHelper(DeviceDataStore())
    var dataSource:[Device] = []
    
    //@IBAction var lblPath : NSLabe
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        refreshDeviceList()
    }
    
    func refreshDeviceList() {
        deviceHelper.retrieveSimulatorListFromShell { (result) in
            switch result {
            case .success(_):
                self.updateDeviceList()
                
            case .failure(let error):
                print("error : \(error)")
            }
        }
    }
    
    func openPanel() {
        
        let deviceDic =  self.getUpdatedDeviceList().map {
            $0.dictionary
        }
        
        let multiSelection = MultiSelectViewController.instantiate()
        multiSelection.setDataSource(deviceDic)
        self.presentAsModalWindow(multiSelection)
        return
        
        let panel = NSOpenPanel()
        panel.canChooseFiles = true
        panel.allowsMultipleSelection = false
        panel.allowedFileTypes = ["app"]
        panel.begin { (modalResponse) in
            
        }
    }
    
    @IBAction func installClicked(_ sender: Any){
        let udidList =  self.getUpdatedDeviceList().map {
            $0.udid!
            }[4..<7]
        
        let bootHelper = DeviceBootHelper()
        bootHelper.bootDevices(Array(udidList))
    }
    
    @IBAction func appPathSelected(sender: NSPopUpButton) {
        openPanel()
    }
    
    @IBAction func refreshDevicesClicked( sender:AnyObject) {
        self.refreshDeviceList()
    }
    
    func updateDeviceList() {
        let devices = getUpdatedDeviceList()
        self.dataSource = devices
    }
    
    private func getUpdatedDeviceList() -> [Device]{
        return self.deviceHelper.getSimulatorList()
    }
    
    
    func bootDevices(_ list:[String]) {
        
    }
    
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

