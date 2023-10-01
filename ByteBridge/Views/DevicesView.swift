//
//  DevicesView.swift
//  ByteBridge
//
//  Created by John on 9/28/23.
//

import SwiftUI
import CoreBluetooth

struct DevicesView: View {
    @StateObject var bluetoothManager = BluetoothManager()
    @State var showDevicePicker = false
    @State var connectedDevices: [CBPeripheral] = []
    @State var savedDevices: [CBPeripheral] = []
    @State var discoveredServices: [CBService] = []
    
    var body: some View {
        VStack {
            //ScrollView {
            //    DeviceView(deviceName: "Device 1", deviceUUID: "123456789")
            //        .padding([.leading, .trailing])
            //    DeviceView(deviceName: "Device 2", deviceUUID: "123456789")
            //        .padding([.leading, .trailing])
            //}
            
            // FIX A device can be clicked multiple times causing a clash of uuid values in list
            List(savedDevices, id: \.identifier) { device in
                VStack {
                    HStack {
                        Text(device.name ?? "Unknown")
                        Spacer()
                        if device == bluetoothManager.connectedPeripheral {
                            Text("Connected")
                            Button("Disconnect") {
                                bluetoothManager.disconnectFromDevice(device)
                            }
                        } else {
                            Button("Connect") {
                                bluetoothManager.connectToDevice(device)
                                print("Connect Pressed")
                            }
                        }
                    }
                }
            }
            // FIX ! Crash issue later
            List(bluetoothManager.discoveredServices!, id: \.uuid) { service in
                Text(service.description)
            }
            Spacer()
            Button(action: {
                showDevicePicker = true
                bluetoothManager.startScan()
            }, label: {
                Capsule()
                    .foregroundStyle(Color(.blue).gradient)
                    .frame(width: 300, height: 50)
                    .overlay(alignment: .center, content: {
                        Text("Add Device")
                            .foregroundStyle(Color(.black))
                            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                            .bold()
                    })
                    .overlay(alignment: .leading) {
                        Image(systemName: "plus.square.fill")
                            .foregroundStyle(Color(.black))
                            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                            .padding(.leading, 15)
                    }
            })
            .popover(isPresented: $showDevicePicker, content: {
                            VStack {
                                List(bluetoothManager.discoveredPeripherals, id: \.identifier) { device in
                                    Text(device.name ?? "Unknown")
                                        .onTapGesture {
                                            savedDevices.append(device)
                                            showDevicePicker = false
                                            bluetoothManager.stopScan()
                                        }
                                }
                                Button("Cancel") {
                                    showDevicePicker = false
                                    bluetoothManager.stopScan()
                                }
                            }
                        })
        }
        .padding(.bottom, 25)
    }
}

struct DeviceView: View {
    var deviceName = ""
    var deviceUUID = ""
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .foregroundStyle(Color(.white))
            .frame(height: 125)
            .overlay(alignment: .topLeading, content: {
                VStack {
                    Text(deviceName)
                        .foregroundStyle(Color(.black))
                        .font(.title)
                    Text(deviceUUID)
                        .foregroundStyle(Color(.black))
                        .font(.subheadline)
                }
                .padding()
            })
    }
}

#Preview {
    ContentView()
}
