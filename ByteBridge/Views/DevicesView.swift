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
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    VStack {
                        RoundedRectangle(cornerRadius: 15, style: .continuous)
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
}

struct DeviceView: View {
    var deviceName = ""
    var deviceUUID = ""
    var body: some View {
        Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
            RoundedRectangle(cornerRadius: 15, style: .continuous)
                .foregroundStyle(.ultraThinMaterial)
                .overlay(RoundedRectangle(cornerRadius: 15, style: .continuous).strokeBorder(.thinMaterial, lineWidth: 3, antialiased: true))
                .overlay(alignment: .topLeading, content: {Text("Pi-Pico").font(.title).foregroundStyle(Color(.black)).padding(.top, 10).padding(.leading, 15)})
                .overlay(alignment: .bottomLeading, content: {Text("59ecc024-8316-4d2b-ae84-976e08bed3dd").font(.subheadline).foregroundStyle(Color(.black)).padding(.bottom, 10).padding(.leading, 15)})
                .overlay(alignment: .trailing, content: {Image(systemName: "chevron.forward").font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/).foregroundStyle(Color(.black)).padding(20)})
                .frame(height: 75)
        })
    }
}


struct ServicesView: View {
    var body: some View {
        ScrollView {
            VStack {
                RoundedRectangle(cornerRadius: 15, style: .continuous)
            }
        }
    }
}

#Preview {
    ContentView()
}
