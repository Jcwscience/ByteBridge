//
//  ContentView.swift
//  ByteBridge
//
//  Created by John on 9/26/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var bluetoothManager = BluetoothManager()
    @State var selection = 1
    var body: some View {
        
        NavigationStack {
            TabView(selection: $selection) {
                Group {
                    DevicesView(bluetoothManager: bluetoothManager)
                    .tabItem {
                        Image(systemName: "cpu")
                        Text("Devices")
                    }.tag(1)

                    DashboardView(bluetoothManager: bluetoothManager)
                        .tabItem {
                            Image(systemName: "gauge.with.dots.needle.bottom.100percent")
                            Text("Dashboard")
                        }.tag(2)
                    SettingsView()
                        .navigationTitle("Settings")
                        .tabItem {
                            Image(systemName: "gear")
                            Text("Settings")
                        }.tag(3)
                }
                .toolbarBackground(.visible, for: .tabBar)
                .toolbarBackground(Color(.secondarySystemFill), for: .tabBar)
                //.background(content: {
                //    AuroraView()
                //        .ignoresSafeArea()
                //})
            }
        }
    }
}


#Preview {
    ContentView()
        //.environment(\.colorScheme, .dark)
}
