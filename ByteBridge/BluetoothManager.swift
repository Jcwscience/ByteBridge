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
    @Published var discoveredServices: [CBService]? = []

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
        // Here you can access peripheral.services to see the discovered services
    }
    
    func connectToDevice(_ peripheral: CBPeripheral) {
        centralManager.connect(peripheral, options: nil)
    }
    
    func disconnectFromDevice(_ peripheral: CBPeripheral) {
        guard let connectedPeripheral = connectedPeripheral else { return }
        centralManager.cancelPeripheralConnection(connectedPeripheral)
    }

    // Add these delegate functions to know when connected or disconnected:
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
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
