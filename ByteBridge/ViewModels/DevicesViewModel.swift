//
//  DevicesViewModel.swift
//  ByteBridge
//
//  Created by John Wallace on 10/26/23.
//

import Foundation
import CoreBluetooth

class DevicesViewModel: ObservableObject, BluetoothServiceDelegate {
    @Published var devices: [CBPeripheral] = []
    @Published var savedDevices: [CBPeripheral] = []
    @Published var connectedDevices: [BTDevice] = []
    @Published var isScanning: Bool = false

    private let bluetoothService = BluetoothService()

    init() {
        bluetoothService.delegate = self
        //self.savedDevices = DataService.loadSavedDevices()
    }

    func startScanning() {
        devices.removeAll()
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
        if !connectedDevices.contains(where: { $0.id == device.identifier }) {
            let btDevice = BTDevice(id: device.identifier, name: device.name ?? "Unknown")
            connectedDevices.append(btDevice)
        }
    }
    
    func didDisconnectFromDevice(_ device: CBPeripheral, error: Error?) {
        connectedDevices.removeAll(where: { $0.id == device.identifier })
    }
    
    func didDiscoverDevice(_ device: CBPeripheral) {
        if !devices.contains(where: { $0.identifier == device.identifier }) {
            devices.append(device)
        }
    }

    func didUpdateState(_ state: CBManagerState) {
        if state != .poweredOn {
            isScanning = false
        }
    }
    
    func didDiscoverServices(for device: CBPeripheral, services: [BTService]) {
        if let index = connectedDevices.firstIndex(where: { $0.id == device.identifier }) {
            connectedDevices[index].services = services
        }
    }
}

