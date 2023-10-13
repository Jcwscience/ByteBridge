//
//  BluetoothManager.swift
//  ByteBridge
//
//  Created by John on 9/26/23.
//

import Foundation
import CoreBluetooth

class BluetoothManager: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate, ObservableObject {
    var centralManager: CBCentralManager!
    @Published var discoveredPeripherals: [CBPeripheral] = []
    @Published var connectedPeripheral: CBPeripheral?
    @Published var isConnected = false
    @Published var discoveredServices: [CBService]? = []
    @Published var characteristics: [BluetoothCharacteristic] = []

    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }

    func startScan() {
        discoveredPeripherals.removeAll()
        centralManager.scanForPeripherals(withServices: nil, options: nil)
    }

    func stopScan() {
        centralManager.stopScan()
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            // You can start scanning here if needed
        } else {
            // Handle other states
        }
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if !discoveredPeripherals.contains(where: { $0.identifier == peripheral.identifier }) {
            discoveredPeripherals.append(peripheral)
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        discoveredServices = peripheral.services
        guard let services = peripheral.services else { return }
        
        for service in services {
            discoverCharacteristics(for: service)
        }
        // Here you can access peripheral.services to see the discovered services
    }
    
    func discoverCharacteristics(for service: CBService) {
        connectedPeripheral?.discoverCharacteristics(nil, for: service) // nil to discover all characteristics for the service
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }
        for characteristic in characteristics {
            updateOrCreateCharacteristic(uuid: characteristic.uuid)
            if characteristic.properties.contains(.notify) {
                peripheral.setNotifyValue(true, for: characteristic)
            }
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        guard let value = characteristic.value else { return }
        updateOrCreateCharacteristic(uuid: characteristic.uuid, dataValue: value)
    }

    func updateOrCreateCharacteristic(uuid: CBUUID, dataValue: Data? = nil, label: String? = nil, debugValue: String? = nil) {
        if let index = characteristics.firstIndex(where: { $0.uuid == uuid}) {
            // Found: Update the characteristic at the found index
            if let dataValue = dataValue {
                characteristics[index].dataValue = dataValue
            }
            if let label = label {
                characteristics[index].label = label
            }
            if let debugValue = debugValue {
                characteristics[index].debugValue = debugValue
            }
        } else {
            let newCharacteristic = BluetoothCharacteristic(uuid: uuid, dataValue: dataValue, label: label ?? "", debugValue: debugValue)
            characteristics.append(newCharacteristic)
        }
    }
    
    func connectToDevice(_ peripheral: CBPeripheral) {
        centralManager.connect(peripheral, options: nil)
    }
    
    func disconnectFromDevice(_ peripheral: CBPeripheral) {
        guard let connectedPeripheral = connectedPeripheral else { return }
        centralManager.cancelPeripheralConnection(connectedPeripheral)
        isConnected = false
    }

    // Add these delegate functions to know when connected or disconnected:
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        isConnected = true
        connectedPeripheral = peripheral
        peripheral.delegate = self
        peripheral.discoverServices(nil)
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        if peripheral == connectedPeripheral {
            connectedPeripheral = nil
        }
        // You can handle errors here or notify the user if needed
    }

}

class BluetoothCharacteristic: ObservableObject {
    let uuid: CBUUID
    @Published var dataValue: Data?
    @Published var label: String
    @Published var debugValue: String?
    
    init(uuid: CBUUID, dataValue: Data? = nil, label: String, debugValue: String? = nil) {
        self.uuid = uuid
        self.dataValue = dataValue
        self.label = label
        self.debugValue = debugValue
    }
}
