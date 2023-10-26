//
//  DevicesView.swift
//  ByteBridge
//
//  Created by John Wallace on 10/26/23.
//

import SwiftUI

struct DevicesView: View {
    @ObservedObject var viewModel: DevicesViewModel
    @State var isPickerShown = false
    var body: some View {
        NavigationStack {
            VStack {
                Button(action: {
                    isPickerShown = true
                }, label: {
                    RoundedRectangle(cornerRadius: 20, style: .circular)
                        .foregroundStyle(.fill)
                        .overlay {
                            Text("Add Device").font(.largeTitle)
                        }
                        .frame(height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                })
                List(viewModel.savedDevices, id: \.identifier) { device in
                    NavigationLink(destination: DeviceDetailsView(viewModel: viewModel, device: device).navigationTitle(device.name ?? "Unknown"), label: {
                        Text(device.name ?? "Unknown")
                    })
                }
                Spacer()
            }
            .padding()
        }
        .sheet(isPresented: $isPickerShown, content: {
            VStack {
                HStack {
                    Button(action: {
                        isPickerShown = false
                    }, label: {
                        Text("Cancel").font(.headline)
                    })
                }
                .padding(.top)
                List(viewModel.devices, id: \.identifier) { device in
                    if let name = device.name {
                        Button(action: {
                            viewModel.saveDevice(device)
                            isPickerShown = false
                        }, label: {
                            Text(name)
                        })
                    }
                }
                Spacer()
            }
            .onAppear(perform: {
                if !viewModel.isScanning {
                    viewModel.startScanning()
                }
            })
            .onDisappear(perform: {
                if viewModel.isScanning {
                    viewModel.stopScanning()
                }
            })
            .padding()
        })
    }
}

#Preview {
    ContentView()
}
