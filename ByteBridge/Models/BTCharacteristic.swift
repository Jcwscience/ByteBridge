//
//  BTCharacteristic.swift
//  ByteBridge
//
//  Created by John Wallace on 10/26/23.
//

import Foundation
import CoreBluetooth

class BTCharacteristic: ObservableObject, Identifiable {
    let id: CBUUID
    
    init(id: CBUUID) {
        self.id = id
    }
}
