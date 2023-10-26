//
//  DataService.swift
//  ByteBridge
//
//  Created by John Wallace on 10/26/23.
//

import Foundation
import CoreBluetooth

class DataService {
    private static let savedDevicesKey = "SavedDevices"

    static func saveDevice(_ device: CBPeripheral) {
        let deviceData = try? NSKeyedArchiver.archivedData(withRootObject: device, requiringSecureCoding: false)
        if let data = deviceData {
            var savedDevicesData = UserDefaults.standard.array(forKey: savedDevicesKey) as? [Data] ?? []
            savedDevicesData.append(data)
            UserDefaults.standard.set(savedDevicesData, forKey: savedDevicesKey)
        }
    }

    static func loadSavedDevices() -> [CBPeripheral] {
        guard let savedDevicesData = UserDefaults.standard.array(forKey: savedDevicesKey) as? [Data] else { return [] }

        return savedDevicesData.compactMap { data in
            return try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? CBPeripheral
        }
    }
}
