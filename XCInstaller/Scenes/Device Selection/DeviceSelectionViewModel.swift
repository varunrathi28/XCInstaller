//
//  DeviceSelectionViewModel.swift
//  XCInstaller
//
//  Created by VR on 24/01/21.
//  Copyright © 2021 VR. All rights reserved.
//

import Foundation

class DeviceSelectionViewModel {
    private var cellModels: [DeviceCellViewModel]
    var numberOfRows: Int {
        cellModels.count
    }
    
    init (_ deviceModels:[DeviceCellViewModel]) {
        self.cellModels = deviceModels
    }
    
    func cellModel(at indexpath:NSIndexPath) -> DeviceCellViewModel{
        return cellModels[indexpath.item]
    }
    
    func getSelectedDeviceIds() -> [String] {
        return   cellModels.filter { $0.selected == true}
            .map{
                $0.udid
        }
    }
        
            
           
}
