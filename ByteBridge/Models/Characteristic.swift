//
//  Characteristic.swift
//  ByteBridge
//
//  Created by John Wallace on 10/26/23.
//

import Foundation
import CoreBluetooth

class Characteristic: ObservableObject, Identifiable {
    let id: CBUUID
    
    init(id: CBUUID) {
        self.id = id
    }
}
