//
//  DevicesView.swift
//  ByteBridge
//
//  Created by John on 9/28/23.
//

import SwiftUI
import CoreBluetooth

struct OldDevicesView: View {
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
                        NavigationLink(destination: {
                            DeviceOverview(bluetoothManager: bluetoothManager, device: device).navigationTitle(device.name ?? "Unknown")
                        }, label: {
                            Text(device.name ?? "Unknown")
                        })
                    }
                    Spacer()
                }
            }
        }
        .sheet(isPresented: $showDevicePicker, content: {
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
        NavigationStack {
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
                    ForEach(bluetoothManager.discoveredCharacteristics) {char in
                        CharacteristicItemView(characteristic: char)
                    }
                    Spacer()
                }
            }
        }
    }
}

struct CharacteristicItemView: View {
    @StateObject var characteristic: CharacteristicWrapper
    var body: some View {
        VStack(alignment: .leading, content: {
            Text("UUID: " + characteristic.id.uuidString).font(.footnote)
            if let value = characteristic.value {
                Text("Value: " + value)
            }
        })
    }
}


#Preview {
    ContentView()
}
