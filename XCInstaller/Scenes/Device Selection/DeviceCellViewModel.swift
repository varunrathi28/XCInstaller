//
//  DeviceCellViewModel.swift
//  XCInstaller
//
//  Created by VR on 24/01/21.
//  Copyright © 2021 VR. All rights reserved.
//

import Foundation

protocol CheckboxCellRepresentable{
    var title:String { get }
    var state: String { get }
    var udid: String { get }
    var selected:Bool {get set}
    
    func setSelection(_ selected:Bool)
}

class DeviceCellViewModel: CheckboxCellRepresentable {
    
    let udid:String
    let title:String
    let state:String
    var selected:Bool
    
    init(id udid:String,
         name:String,
         state:String,
         isSelected:Bool){
        
        self.udid = udid
        self.title = name
        self.state = state
        self.selected = isSelected
    }
    
    func setSelection(_ selected:Bool){
        self.selected = selected
    }
}

extension DeviceCellViewModel {
    convenience init(_ device:Device) {
        let name = device.name ?? ""
        let udid = device.udid ?? ""
        let state = device.state ?? ""
        let selected = false
        self.init(id: udid, name: name, state: state, isSelected: selected)
    }
}
