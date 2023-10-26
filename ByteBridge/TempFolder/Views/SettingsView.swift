//
//  SettingsView.swift
//  ByteBridge
//
//  Created by John on 9/28/23.
//

import SwiftUI

enum Theme: String, CaseIterable, Identifiable {
    case system, light, dark
    var id: Self { self }
}

struct SettingsView: View {
    @State var appTheme: Theme = .system
    var body: some View {
        List{
            Section {
                Toggle(isOn: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Is On@*/.constant(true)/*@END_MENU_TOKEN@*/) {
                    Text("Setting 1")
                }
                Toggle(isOn: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Is On@*/.constant(true)/*@END_MENU_TOKEN@*/) {
                    Text("Setting 2")
                }
            }
            .listRowBackground(Color(.settingsBackground))
            Section {
                Picker(selection: $appTheme, label: Text("Appearance")) {
                    Text("System").tag(Theme.system)
                    Text("Light").tag(Theme.light)
                    Text("Dark").tag(Theme.dark)
                }
                .pickerStyle(.inline)
            }
            .listRowBackground(Color(.settingsBackground))
        }
    }
}

#Preview {
    SettingsView()
}
