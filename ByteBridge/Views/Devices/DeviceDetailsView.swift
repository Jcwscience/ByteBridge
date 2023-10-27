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
    @State private var deviceServices: [BTService] = []

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
            ForEach(deviceServices) { service in
                ServiceView(service: service)
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
