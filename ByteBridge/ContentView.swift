//
//  ContentView.swift
//  ByteBridge
//
//  Created by John on 9/26/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        
        NavigationStack {
            TabView {
                Group {
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
