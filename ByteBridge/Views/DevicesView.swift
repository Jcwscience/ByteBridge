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
    @State var savedDevices: [CBPeripheral] = []
    var body: some View {
        NavigationStack {
            ZStack {
                //AuroraView()
                Rectangle()
                    .foregroundStyle(Color(.green).gradient)
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
                            NavigationLink(destination: ServicesView(bluetoothManager: bluetoothManager, device: device).navigationTitle("Services"), label: {
                                RoundedRectangle(cornerRadius: 15)
                                    .foregroundStyle(.thinMaterial)
                                    .frame(height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                                    .overlay {Text(device.name ?? "Unknown").font(.largeTitle).foregroundStyle(.primary)}
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
                    Button(action: {
                        if !savedDevices.contains(device) {
                            savedDevices.append(device)
                        }
                        showDevicePicker = false
                    }, label: {
                        Text(device.name ?? "Unknown")
                    })
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

struct ServicesView: View {
    @State var bluetoothManager: BluetoothManager
    @State var device: CBPeripheral
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundStyle(Color(.green).gradient)
                .ignoresSafeArea()
            VStack {
                Button(action: {
                    bluetoothManager.isConnected ? bluetoothManager.connectToDevice(device) : bluetoothManager.disconnectFromDevice(device)
                }, label: {
                    Text(bluetoothManager.isConnected ? "Disconnect" : "Connect")
                })
                //ScrollView {
                    //List(bluetoothManager.discoveredServices, id: \.uuid) { service in                        Text(service.uuid.uuidString)
                    //}
                //}
            }
        }
    }
}


#Preview {
    DevicesView()
}
