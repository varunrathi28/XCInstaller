//
//  Device+Dic.swift
//  XCInstaller
//
//  Created by VR on 24/01/21.
//  Copyright © 2021 VR. All rights reserved.
//

import Foundation

extension Device {
    var dictionary: [String:String] {
        return ["name": self.name ?? "",
                "state":self.state ?? "",
                "available": "\(self.available)"
        ]
    }
}
