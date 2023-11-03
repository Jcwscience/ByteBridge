//
//  BTService.swift
//  ByteBridge
//
//  Created by John Wallace on 10/26/23.
//

import Foundation
import CoreBluetooth

class BTService: ObservableObject, Identifiable {
    let parentUUID: UUID
    let id: CBUUID
    let primary: Bool
    @Published var characteristics: [BTCharacteristic]
    
    init(parentUUID: UUID, id: CBUUID, primary: Bool, characteristics: [BTCharacteristic] = []) {
        self.parentUUID = parentUUID
        self.id = id
        self.primary = primary
        self.characteristics = characteristics
    }
}
