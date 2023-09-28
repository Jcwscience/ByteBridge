//
//  ContentView.swift
//  ByteBridge
//
//  Created by John on 9/26/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            DevicesView()
                .tabItem {
                    Image(systemName: "cpu")
                    Text("Devices")
                }
            DashboardView()
                .tabItem {
                    Image(systemName: "gauge.with.dots.needle.bottom.100percent")
                    Text("Dashboard")
                }
            SettingsView()
                .navigationTitle("Settings")
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
        }
    }
}


#Preview {
    ContentView()
}
