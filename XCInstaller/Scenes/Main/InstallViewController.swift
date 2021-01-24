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
    
    @IBOutlet var btnSelectedSimulators: NSPopUpButton!
    @IBOutlet var popUpAppPath: NSPopUpButton!
    @IBOutlet var btnInstall: NSButton!
    var deviceHelper:DeviceHelper = DeviceHelper(DeviceDataStore())
    var dataSource:[Device] = []
    var selectedDeviceIds:[String] = [] {
        didSet {
            self.updateSelectedSimulators()
        }
    }
    var selectedAppPath:String = ""
   
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
        let panel = NSOpenPanel()
        panel.canChooseFiles = true
        panel.allowsMultipleSelection = false
        panel.allowedFileTypes = ["app"]
        panel.begin { (result) in
            guard result == .OK else { return }
            
            if let path = panel.urls.first?.absoluteString {
                self.selectedAppPath = path
            }
        }
    }
    
    func openDeviceSelectionMenu() {
        let cellModels =  self.getUpdatedDeviceList().map {
            DeviceCellViewModel.init($0)
        }
        let viewModel = DeviceSelectionViewModel(cellModels)
        let multiSelection = MultiSelectViewController.instantiate(viewModel) {[weak self] udids in
            guard let self = self else { return }
            self.selectedDeviceIds = udids
        }
        self.presentAsModalWindow(multiSelection)
    }
    
    @IBAction func installClicked(_ sender: Any){
        guard selectedDeviceIds.count > 0 else {
            print("Select atleast one device")
            return
        }
        let bootHelper = DeviceBootHelper()
        bootHelper.bootDevices(devices: selectedDeviceIds, selectedAppPath)
    }
    
    @IBAction func appPathSelected(sender: NSPopUpButton) {
        openPanel()
    }
    
    @IBAction func btnSelectDevicesClicked(sender : NSPopUpButton){
        openDeviceSelectionMenu()
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
    
    func updateSelectedSimulators() {
        if selectedDeviceIds.isEmpty {
            btnSelectedSimulators.stringValue = "Select devices"
        }
        else{
            btnSelectedSimulators.stringValue = "+\(selectedDeviceIds.count) devices selected"
        }
    }
    
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

