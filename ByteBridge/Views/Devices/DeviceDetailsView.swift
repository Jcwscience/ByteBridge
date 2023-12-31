//
//  DeviceDetailsView.swift
//  ByteBridge
//
//  Created by John Wallace on 10/26/23.
//

import SwiftUI
import CoreBluetooth

struct DeviceDetailsView: View {
    @ObservedObject var controller: DevicesController
    var device: CBPeripheral

    var body: some View {
        VStack {
            Button(action: {
                controller.connectedDevices.contains(where: {$0.identifier == device.identifier}) ? controller.disconnectFromDevice(device) : controller.connectToDevice(device)
            }, label: {
                Capsule(style: .circular)
                    .foregroundStyle(Color(controller.connectedDevices.contains(where: {$0.identifier == device.identifier}) ? .red : .green).gradient)
                    .overlay {
                        Text(controller.connectedDevices.contains(where: {$0.identifier == device.identifier}) ? "Disconnect" : "Connect")
                            .foregroundStyle(.foreground)
                    }
                    .frame(height: 50)
            })
            ForEach(controller.discoveredServices) { service in
                if service.parentUUID == device.identifier {
                    ServiceView(service: service)
                }
            }
            Spacer()
        }
        .padding()
    }
}

struct ServiceView: View {
    @State var service: BTService
    var body: some View {
        VStack {
            Text(service.id.uuidString)
        }
    }
}


#Preview {
    ContentView()
}
