//
//  BluetoothManager.swift
//  ByteBridge
//
//  Created by John on 9/26/23.
//

import Foundation
import CoreBluetooth

enum DecodedValueType {
    case string(String)
    case int(Int)
    case float(Float)
}


class DataProcessor {
    static func decodeCharacteristicsData(_ data: Data) -> DecodedValueType {
        guard let firstByte = data.first else {
            fatalError("Received empty data!")
        }

        // Depending on the flag in the first byte, decode the data accordingly
        switch firstByte {
        case 1:
            let stringData = data.dropFirst()
            if let decodedString = String(data: stringData, encoding: .utf8) {
                return .string(decodedString)
            } else {
                fatalError("Error decoding String!")
            }
        case 2:
            let intData = data.dropFirst()
            let intValue = intData.withUnsafeBytes { $0.load(as: Int.self) }
            return .int(intValue)
        case 3:
            let floatData = data.dropFirst()
            let floatValue = floatData.withUnsafeBytes { $0.load(as: Float.self) }
            return .float(floatValue)
        default:
            fatalError("Unknown data type!")
        }
    }
}


class BluetoothManager: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate, ObservableObject {
    
    var centralManager: CBCentralManager!
    var peripheral: CBPeripheral?
    
    // Changed: Instead of one characteristic and its value, we store all characteristics and their values
    @Published var servicesData: [CBService : [CBCharacteristic : DecodedValueType]] = [:]
    @Published var isConnected: Bool = false

    
    let targetDeviceName = "Pi-Pico"

    // Initializer
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            print("Bluetooth is powered on")
        case .poweredOff:
            print("Bluetooth is powered off")
        default:
            break
        }
    }

    func startScanning() {
        // Only scan for devices if Bluetooth is powered on.
        if centralManager.state == .poweredOn {
            centralManager.scanForPeripherals(withServices: nil, options: nil)
        }
    }


    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if let deviceName = advertisementData[CBAdvertisementDataLocalNameKey] as? String, deviceName == targetDeviceName {
            self.peripheral = peripheral
            self.centralManager.stopScan()
            self.centralManager.connect(peripheral, options: nil)
        }
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.delegate = self
        isConnected = true
        // Replace with your device's service UUID
        peripheral.discoverServices([CBUUID(string: "C04CD54E-6C04-4FA2-8AFB-93AC92E4A8FE")])
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        isConnected = false
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let services = peripheral.services {
            for service in services {
                peripheral.discoverCharacteristics(nil, for: service)
            }
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }

        for characteristic in characteristics {
            peripheral.setNotifyValue(true, for: characteristic) // Set up notifications for all characteristics
        }
    }


    //func readValue() {
    //    guard let characteristic = targetCharacteristic else { return }
    //    peripheral?.readValue(for: characteristic)
    //}
    //func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
    //    if let data = characteristic.value {
    //        let decodedValue = DataProcessor.decodeCharacteristicsData(data)
    //
    //        if servicesData[characteristic.service] == nil {
    //            servicesData[characteristic.service] = [:]
    //        }
    //        servicesData[characteristic.service]?[characteristic] = decodedValue
    //    }
    //}
    
    func disconnect() {
        if let connectedPeripheral = self.peripheral {
            centralManager.cancelPeripheralConnection(connectedPeripheral)
            isConnected = false
        }
    }
}
