//
//  MultiSelectTableCell.swift
//  XCInstaller
//
//  Created by VR on 24/01/21.
//  Copyright © 2021 VR. All rights reserved.
//

import Cocoa

class MultiSelectTableCell: NSTableCellView {
    
    @IBOutlet weak var lblSimulatorName:NSTextField!
    @IBOutlet weak var lblState: NSTextField!
    @IBOutlet weak var checkBox: NSButton!
    @IBOutlet weak var imgAvailable:NSImageView!
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
    
    func configureData(_ dic:[String:AnyObject]) {
        guard let simulatorName = dic["name"] as? String else { return }
        self.lblSimulatorName.stringValue = simulatorName
        self.lblState.stringValue = dic["state"] as? String ?? ""
    }
    
}
