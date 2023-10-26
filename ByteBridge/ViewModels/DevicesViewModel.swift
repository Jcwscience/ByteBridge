//
//  DevicesViewModel.swift
//  ByteBridge
//
//  Created by John Wallace on 10/26/23.
//

import Foundation
import CoreBluetooth

class DevicesViewModel: ObservableObject {
    @Published var devices: [CBPeripheral] = []
    @Published var savedDevices: [CBPeripheral] = []
    @Published var connectedDevices: [Device] = []
    @Published var isScanning: Bool = false

    private let bluetoothService = BluetoothService()

    init() {
        bluetoothService.delegate = self // Assuming you have a delegate or similar mechanism to update the ViewModel
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
}

// Delegate or similar mechanism to update the ViewModel based on Bluetooth events
extension DevicesViewModel: BluetoothServiceDelegate {
    func didConnectToDevice(_ device: CBPeripheral) {
        if !connectedDevices.contains(where: { $0.id == device.identifier }) {
            let wrappedDevice = Device(id: device.identifier)
            connectedDevices.append(wrappedDevice)
            device.discoverServices()
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
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        print(peripheral.services)
        if let index = connectedDevices.firstIndex(where: {$0.id == peripheral.identifier}) {
            if let discoveredServices = peripheral.services {
                print(discoveredServices)
                var services:[Service] = []
                for discoveredService in discoveredServices {
                    let service = Service(id: discoveredService.uuid, primary: discoveredService.isPrimary)
                    services.append(service)
                }
                connectedDevices[index].services = services
            }
        }
    }
}
