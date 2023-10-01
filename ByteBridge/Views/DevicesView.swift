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
    
    var body: some View {
        VStack {
            //ScrollView {
            //    DeviceView(deviceName: "Device 1", deviceUUID: "123456789")
            //        .padding([.leading, .trailing])
            //    DeviceView(deviceName: "Device 2", deviceUUID: "123456789")
            //        .padding([.leading, .trailing])
            //}
            List(connectedDevices, id: \.identifier) { device in
                HStack {
                    Text(device.name ?? "Unknown")
                    Spacer()
                    if device == bluetoothManager.connectedPeripheral {
                        Text("Connected")
                        Button("Disconnect") {
                            // Logic for disconnect
                        }
                    } else {
                        Button("Connect") {
                            // Logic for connect
                        }
                    }
                }
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
                                            connectedDevices.append(device)
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
        .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
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
