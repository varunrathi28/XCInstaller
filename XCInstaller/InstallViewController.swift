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
    
    //@IBAction var lblPath : NSLabe
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

