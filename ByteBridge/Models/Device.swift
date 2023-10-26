//
//  Device.swift
//  ByteBridge
//
//  Created by John Wallace on 10/26/23.
//

import Foundation
import CoreBluetooth

class Device: ObservableObject, Identifiable {
    let id: UUID
    let name: String
    @Published var services:[Service]
    
    init(id:UUID, name:String = "Unknown", services:[Service] = []) {
        self.id = id
        self.name = name
        self.services = services
    }
}
