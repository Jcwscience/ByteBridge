//
//  DevicesView.swift
//  ByteBridge
//
//  Created by John Wallace on 10/26/23.
//

import SwiftUI

struct DevicesView: View {
    @ObservedObject var controller: DevicesController
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
                ScrollView {
                    ForEach(controller.savedDevices, id: \.identifier) { device in
                        NavigationLink(destination: DeviceDetailsView(controller: controller, device: device), label: {
                            RoundedRectangle(cornerRadius: 20, style: .circular)
                                .foregroundStyle(.fill)
                                .overlay {
                                    Text(device.name ?? "Unknown").font(.title)
                                }
                                .overlay(alignment: .trailing, content: {
                                    Image(systemName: "chevron.right").font(.title)
                                        .padding(.trailing)
                                })
                                .frame(height: 100)
                        })
                    }
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
                List(controller.discoveredDevices, id: \.identifier) { device in
                    if let name = device.name {
                        Button(action: {
                            controller.saveDevice(device)
                            isPickerShown = false
                        }, label: {
                            Text(name)
                        })
                    }
                }
                Spacer()
            }
            .onAppear(perform: {
                if !controller.isScanning {
                    controller.startScanning()
                }
            })
            .onDisappear(perform: {
                if controller.isScanning {
                    controller.stopScanning()
                }
            })
            .padding()
        })
    }
}

#Preview {
    ContentView()
}
