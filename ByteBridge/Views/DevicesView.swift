//
//  DevicesView.swift
//  ByteBridge
//
//  Created by John on 9/28/23.
//

import SwiftUI
import CoreBluetooth

struct DevicesView: View {
    @StateObject var bluetoothManager: BluetoothManager
    @State var showDevicePicker = false
    @State var savedDevices: [CBPeripheral] = []
    var body: some View {
        NavigationStack {
            ZStack {
                //AuroraView()
                Rectangle()
                    .foregroundStyle(Color(.gray).gradient)
                    .ignoresSafeArea()
                RoundedRectangle(cornerRadius: 15, style: .continuous)
                    .foregroundStyle(.ultraThinMaterial)
                    .padding()
                VStack {
                    Button(action: {
                        showDevicePicker = true
                    }, label: {
                        RoundedRectangle(cornerRadius: 15)
                            .foregroundStyle(.thickMaterial)
                            .frame(height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                            .overlay(alignment: .center, content: {
                                Text("Add Device")
                                    .font(.largeTitle)
                            })
                            .padding([.leading, .trailing, .top], 40)
                    })
                    ScrollView {
                        ForEach(savedDevices, id: \.identifier) { device in
                            NavigationLink(destination: DeviceOverview(bluetoothManager: bluetoothManager, device: device).navigationTitle(device.name ?? "Unknown").navigationBarTitleDisplayMode(.large), label: {
                                RoundedRectangle(cornerRadius: 15)
                                    .foregroundStyle(.thinMaterial)
                                    .frame(height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                                    .overlay {Text(device.name ?? "Unknown").font(.largeTitle).foregroundStyle(.primary)}
                                    .overlay(alignment: .trailing, content: {Image(systemName: "chevron.right").font(.largeTitle).padding(.trailing)})
                                    .overlay(alignment: .leading, content: {
                                        Circle()
                                            .frame(width: 50)
                                            .padding(.leading)
                                            .foregroundStyle(Color(bluetoothManager.connectedPeripheral == device ? .green : .red))
                                        
                                    })
                                    .scrollTransition {content, phase in content
                                            .opacity(phase.isIdentity ? 1 : 0)
                                            //.rotation3DEffect(
                                            //    .degrees(phase.value * -90),axis: (x: 1.0, y: 0.0, z: 0.0), anchor: phase.value < 0 ? .bottom : .top
                                            //)
                                            //.offset(y: phase.value * -50)
                                    }
                            })
                            .scrollTargetLayout()
                        }
                    }
                    .scrollTargetBehavior(.viewAligned)
                    .padding([.leading, .trailing, .bottom], 40)
                }
            }
        }
        .popover(isPresented: $showDevicePicker, content: {
            ZStack {
                List(bluetoothManager.discoveredPeripherals, id: \.identifier) {device in
                    if device.name != nil {
                        Button(action: {
                            if !savedDevices.contains(device) {
                                savedDevices.append(device)
                            }
                            showDevicePicker = false
                        }, label: {
                            Text(device.name ?? "Unknown")
                        })
                    }
                }
                .onAppear(perform: bluetoothManager.startScan)
                .onDisappear(perform: bluetoothManager.stopScan)
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
            Rectangle().foregroundStyle(Color(.white))
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
