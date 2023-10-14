//
//  DevicesView.swift
//  ByteBridge
//
//  Created by John on 9/28/23.
//

import SwiftUI
import CoreBluetooth

struct DevicesView: View {
    //@StateObject var bluetoothManager = BluetoothManager()
    @StateObject var bluetoothManager: BluetoothManager
    @State var showDevicePicker = false
    @State var savedDevices: [CBPeripheral] = []
    var body: some View {
        NavigationStack {
            ZStack {
                //AuroraView()
                Rectangle()
                    .foregroundStyle(.background)
                    .ignoresSafeArea()
                RoundedRectangle(cornerRadius: 15, style: .circular)
                    .foregroundStyle(.background.secondary)
                    .padding()
                VStack {
                    Button(action: {
                        showDevicePicker = true
                    }, label: {
                        RoundedRectangle(cornerRadius: 15, style: .circular)
                            .foregroundStyle(Color(.systemFill))
                            .frame(height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                            .overlay {
                                Text("Add Device")
                                    .font(.largeTitle)
                            }
                            .padding([.top, .leading, .trailing], 40)
                    })
                    ForEach(savedDevices, id: \.identifier) { device in
                        if let name = device.name {
                            RoundedRectangle(cornerRadius: 15, style: .circular)
                                .foregroundStyle(Color(.systemFill))
                                .frame(height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                                .overlay {
                                    Text(name)
                                        .font(.largeTitle)
                                }
                                .padding([.leading, .trailing], 40)
                        }
                    }
                    Spacer()
                }
            }
        }
        .popover(isPresented: $showDevicePicker, content: {
            ZStack {
                Rectangle()
                    .foregroundStyle(.background.secondary)
                    .ignoresSafeArea()
                    .onAppear(perform: {
                        bluetoothManager.startScan()
                    })
                    .onDisappear(perform: {
                        bluetoothManager.stopScan()
                    })
                VStack {
                    HStack {
                        Spacer()
                        Button("Cancel", action: {showDevicePicker = false}).font(.headline)
                            .padding([.trailing, .top], 30)
                    }
                    List(bluetoothManager.discoveredPeripherals, id: \.identifier) { device in
                        if let name = device.name {
                            Button(action: {
                                if !savedDevices.contains(device) {
                                    savedDevices.append(device)
                                }
                                showDevicePicker = false
                            }, label: {
                                Text(name)
                            })
                        }
                    }
                }
            }
        })
    }
}


struct DevicesTestView: View {
    var body: some View {
        Rectangle()
    }
}



struct DeviceOverview: View {
    @StateObject var bluetoothManager: BluetoothManager
    @State var device: CBPeripheral
    var body: some View {
        ZStack{
            Rectangle().foregroundStyle(Color(.gray).gradient)
                .ignoresSafeArea()
            VStack {
                Button(action: {
                    bluetoothManager.connectedPeripheral == device ? bluetoothManager.disconnectFromDevice(device) : bluetoothManager.connectToDevice(device)
                }, label: {
                    Capsule()
                        .foregroundStyle(Color(bluetoothManager.connectedPeripheral == device ? .red : .green))
                        .frame(height: 50)
                        .overlay{Text(bluetoothManager.connectedPeripheral == device ? "Disconnect" : "Connect")}
                })
                .padding([.leading, .trailing])
                List {
                    if let services = device.services {
                        ForEach(services, id: \.uuid) { service in
                            @State var expanded = true
                            DisclosureGroup(isExpanded: $expanded, content: {
                                ForEach(bluetoothManager.characteristics, id: \.uuid) {characteristic in
                                    
                                    CharacteristicItemView(characteristic: characteristic)
                                }
                            }, label: {
                                Text("Service: " + service.uuid.uuidString)
                            })
                        }
                    }
                }
                Spacer()
            }
        }
    }
}

struct CharacteristicItemView: View {
    @StateObject var characteristic: BluetoothCharacteristic
    var body: some View {
        VStack(alignment: .leading, content: {
            TextField(text: $characteristic.label, label: {Text("User Label")})
            Text("UUID: " + characteristic.uuid.uuidString).font(.footnote)
            if let value = characteristic.dataValue {
                HStack {
                    Text("Value: ")
                    Text(String(data: value, encoding: .utf8) ?? "Invalid Encoding")
                    Spacer()
                }
            }
        })
    }
}


#Preview {
    ContentView()
}
