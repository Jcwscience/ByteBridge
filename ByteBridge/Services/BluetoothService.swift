//
//  BluetoothService.swift
//  ByteBridge
//
//  Created by John Wallace on 10/26/23.
//

import CoreBluetooth

protocol BluetoothServiceDelegate: AnyObject {
    func didDiscoverDevice(_ device: CBPeripheral)
    func didUpdateState(_ state: CBManagerState)
    func didConnectToDevice(_ device: CBPeripheral)
    func didDisconnectFromDevice(_ device: CBPeripheral, error: Error?)
}

class BluetoothService: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    private var centralManager: CBCentralManager?
    private var connectedPeripheral: CBPeripheral?
    
    weak var delegate: BluetoothServiceDelegate?

    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }

    // MARK: - CBCentralManagerDelegate

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        delegate?.didUpdateState(central.state)
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        delegate?.didDiscoverDevice(peripheral)
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        delegate?.didConnectToDevice(peripheral)
        peripheral.discoverServices(nil)
    }

    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        delegate?.didDisconnectFromDevice(peripheral, error: error)
    }

    // MARK: - Public methods

    func startScanning() {
        centralManager?.scanForPeripherals(withServices: nil, options: nil)
    }

    func stopScanning() {
        centralManager?.stopScan()
    }

    func connect(_ device: CBPeripheral) {
        connectedPeripheral = device
        centralManager?.connect(device, options: nil)
    }

    func disconnect(_ device: CBPeripheral) {
        if let connectedPeripheral = self.connectedPeripheral, connectedPeripheral == device {
            centralManager?.cancelPeripheralConnection(device)
        }
    }
    
    // MARK: - CBPeripheralDelegate
    // Handle the delegate methods for the peripheral as needed, e.g., discovering services, characteristics, etc.
}
