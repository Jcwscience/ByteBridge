//
//  BTDevice.swift
//  ByteBridge
//
//  Created by John Wallace on 10/26/23.
//

import Foundation
import CoreBluetooth

class BTDevice: ObservableObject, Identifiable {
    let id: UUID
    let name: String
    
    @Published var services:[BTService]
    
    init(id: UUID, name: String, services: [BTService] = []) {
        self.id = id
        self.name = name
        self.services = services
    }
}
