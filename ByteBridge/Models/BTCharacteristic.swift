//
//  BTCharacteristic.swift
//  ByteBridge
//
//  Created by John Wallace on 10/26/23.
//

import Foundation
import CoreBluetooth

class BTCharacteristic: ObservableObject, Identifiable {
    let parentServiceID: CBUUID
    let id: CBUUID
    
    init(parentServiceID: CBUUID, id: CBUUID) {
        self.parentServiceID = parentServiceID
        self.id = id
    }
}
