//
//  BTService.swift
//  ByteBridge
//
//  Created by John Wallace on 10/26/23.
//

import Foundation
import CoreBluetooth

class BTService: ObservableObject, Identifiable {
    let id: CBUUID
    let primary: Bool
    @Published var characteristics: [BTCharacteristic]
    
    init(id: CBUUID, primary: Bool, characteristics: [BTCharacteristic] = []) {
        self.id = id
        self.primary = primary
        self.characteristics = characteristics
    }
}
