//
//  Data+JsonString.swift
//  XCInstaller
//
//  Created by VR on 23/01/21.
//  Copyright © 2021 VR. All rights reserved.
//

import Foundation

extension Data {
    func getJsonString() -> String {
        return String(data: self, encoding: .utf8) ?? ""
    }
}
