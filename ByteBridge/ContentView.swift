//
//  ContentView.swift
//  ByteBridge
//
//  Created by John on 9/26/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var bluetoothManager = BluetoothManager()
    @State private var gaugeValue: Double = 0.5
    @State var showingSettingsMenu = false

    var body: some View {
        VStack(spacing: 20) {
            // Connection button
            Button(action: {
                if bluetoothManager.isConnected {
                    bluetoothManager.disconnect()
                } else {
                    bluetoothManager.startScanning()
                }
            }) {
                Text(bluetoothManager.isConnected ? "Disconnect" : "Connect")
                    .padding()
                    .background(bluetoothManager.isConnected ? Color.red : Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            //                List(bluetoothManager.discoveredServices, id: \.uuid) { service in
            //                    VStack(alignment: .leading) {
            //                        Text("Service: \(service.uuid.uuidString)")
            //                            .font(.headline)
            //
            //                        ForEach(service.characteristics ?? [], id: \.uuid) { characteristic in
            //                            Text("Characteristic Value: \(bluetoothManager.characteristicsData[characteristic] ?? "N/A")")
            //                                .font(.subheadline)
            //                        }
            //                    }
            //                }
            Button("Settings") {
                showingSettingsMenu.toggle()
            }
            .sheet(isPresented: $showingSettingsMenu, content: {
                SettingsView()
                    .presentationDetents([.medium, .large])
            })
            GaugeView(value: gaugeValue)
                .frame(width: 300, height: 300)
            
            Slider(value: $gaugeValue)
                .padding()
        }
        .padding()
    }
}

struct SettingsView: View {
    var body: some View {
        Text("Settings")
    }
}


#Preview {
    ContentView()
}
