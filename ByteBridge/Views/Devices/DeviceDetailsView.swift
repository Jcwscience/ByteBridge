//
//  DeviceDetailsView.swift
//  ByteBridge
//
//  Created by John Wallace on 10/26/23.
//

import SwiftUI
import CoreBluetooth

struct DeviceDetailsView: View {
    @ObservedObject var viewModel: DevicesViewModel
    var device: CBPeripheral

    var body: some View {
        VStack {
            Button(action: {
                viewModel.connectedDevices.contains(where: {$0.id == device.identifier}) ? viewModel.disconnectFromDevice(device) : viewModel.connectToDevice(device)
            }, label: {
                Capsule(style: .circular)
                    .foregroundStyle(Color(viewModel.connectedDevices.contains(where: {$0.id == device.identifier}) ? .red : .green).gradient)
                    .overlay {
                        Text(viewModel.connectedDevices.contains(where: {$0.id == device.identifier}) ? "Disconnect" : "Connect")
                            .foregroundStyle(.foreground)
                    }
                    .frame(height: 50)
            })
            if let device = viewModel.connectedDevices.first(where: {$0.id == device.identifier}) {
                ForEach(device.services) { service in
                    Text(service.id.uuidString)
                }
            }
            Spacer()
        }
        .padding()
    }
}

struct ServiceView: View {
    @StateObject var service: BTService
    var body: some View {
        VStack {
            Text(service.id.uuidString)
        }
    }
}


#Preview {
    ContentView()
}
