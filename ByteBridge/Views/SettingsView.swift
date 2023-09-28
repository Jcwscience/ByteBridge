//
//  SettingsView.swift
//  ByteBridge
//
//  Created by John on 9/28/23.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        List{
            Toggle(isOn: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Is On@*/.constant(true)/*@END_MENU_TOKEN@*/) {
                Text("Setting 1")
            }
            Toggle(isOn: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Is On@*/.constant(true)/*@END_MENU_TOKEN@*/) {
                Text("Setting 2")
            }
        }
    }
}

#Preview {
    SettingsView()
}
