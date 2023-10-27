//
//  ContentView.swift
//  ByteBridge
//
//  Created by John on 9/26/23.
//

import SwiftUI

struct ContentView: View {
    @State var selection = 1
    let devicesViewModel = DevicesViewModel()
    var body: some View {
        NavigationStack {
            TabView(selection: $selection) {
                Group {
                    DevicesView(viewModel: devicesViewModel)
                    .tabItem {
                        Image(systemName: "cpu")
                        Text("Devices")
                    }.tag(1)

                    DashboardView()
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
            }
        }
    }
}


#Preview {
    ContentView()
        //.environment(\.colorScheme, .dark)
}
