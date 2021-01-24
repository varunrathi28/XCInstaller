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
    
    private var cellModel: CheckboxCellRepresentable? {
        didSet {
            guard let model = self.cellModel else {
                return
            }
            self.lblSimulatorName.stringValue = model.title
            self.lblState.stringValue = model.state
            self.lblState.stringValue = model.state
        }
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
    
    func configureData(_ cellModel: CheckboxCellRepresentable) {
        self.cellModel = cellModel
      

        self.checkBox.state = (cellModel.selected) ? .on : .off
    }
    
    @IBAction func checkBoxClicked(sender: NSButton){
        guard var cellModel = self.cellModel else {
            return
        }
        cellModel.selected = !cellModel.selected
    }
    
}
