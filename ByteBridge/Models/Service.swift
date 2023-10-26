//
//  Service.swift
//  ByteBridge
//
//  Created by John Wallace on 10/26/23.
//

import Foundation
import CoreBluetooth

class Service: ObservableObject, Identifiable {
    let id: CBUUID
    let primary: Bool
    @Published var characteristics: [Characteristic]
    
    init(id: CBUUID, primary: Bool, characteristics: [Characteristic] = []) {
        self.id = id
        self.primary = primary
        self.characteristics = characteristics
    }
}
