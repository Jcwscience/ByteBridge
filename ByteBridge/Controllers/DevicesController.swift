//
//  DevicesController.swift
//  ByteBridge
//
//  Created by John Wallace on 10/30/23.
//

import Foundation
import CoreBluetooth

class DevicesController: BluetoothServiceDelegate, ObservableObject {
    @Published var discoveredDevices: [CBPeripheral] = []
    @Published var savedDevices: [CBPeripheral] = []
    @Published var connectedDevices: [CBPeripheral] = []
    @Published var isScanning: Bool = false
    
    @Published var discoveredServices: [BTService] = []
    @Published var discoveredCharacteristics: [BTCharacteristic] = []

    private let bluetoothService = BluetoothService()

    init() {
        bluetoothService.delegate = self
        //self.savedDevices = DataService.loadSavedDevices()
    }

    func startScanning() {
        discoveredDevices.removeAll()
        isScanning = true
        bluetoothService.startScanning()
    }

    func stopScanning() {
        isScanning = false
        bluetoothService.stopScanning()
    }

    func connectToDevice(_ device: CBPeripheral) {
        bluetoothService.connect(device)
    }

    func disconnectFromDevice(_ device: CBPeripheral) {
        bluetoothService.disconnect(device)
    }
    
    func saveDevice(_ device: CBPeripheral) {
        if !savedDevices.contains(where: { $0.identifier == device.identifier }) {
            savedDevices.append(device)
            //DataService.saveDevice(device)
        }
    }

    // Delegate methods

    func didConnectToDevice(_ device: CBPeripheral) {
        if !connectedDevices.contains(device) {
            connectedDevices.append(device)
        }
    }
    
    func didDisconnectFromDevice(_ device: CBPeripheral, error: Error?) {
        connectedDevices.removeAll(where: {$0.identifier == device.identifier})
    }
    
    func didDiscoverDevice(_ device: CBPeripheral) {
        if !discoveredDevices.contains(where: { $0.identifier == device.identifier }) {
            discoveredDevices.append(device)
        }
    }

    func didUpdateState(_ state: CBManagerState) {
        if state != .poweredOn {
            isScanning = false
        }
    }
    
    func didDiscoverServices(for device: CBPeripheral, services: [BTService]) {
        for service in services {
            discoveredServices.removeAll(where: {$0.parentUUID == device.identifier})
            if !discoveredServices.contains(where: {$0.id == service.id}) {
                discoveredServices.append(service)
            }
        }
    }
    
    func didDiscoverCharacteristics(for device: CBPeripheral, services: [BTService]) {
        for service in services {
            discoveredServices.removeAll(where: {$0.parentUUID == device.identifier})
            if !discoveredServices.contains(where: {$0.id == service.id}) {
                discoveredServices.append(service)
            }
        }
    }
}

