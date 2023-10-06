//
//  DevicesView.swift
//  ByteBridge
//
//  Created by John on 9/28/23.
//

import SwiftUI
import CoreBluetooth

struct DevicesView: View {
    @StateObject var bluetoothManager = BluetoothManager()
    @State var showDevicePicker = false
    @State var savedDevices: [CBPeripheral] = []
    var body: some View {
        NavigationStack {
            ZStack {
                //AuroraView()
                Rectangle()
                    .foregroundStyle(Color(.green).gradient)
                    .ignoresSafeArea()
                RoundedRectangle(cornerRadius: 15, style: .continuous)
                    .foregroundStyle(.ultraThinMaterial)
                    .padding()
                ScrollView {
                    ForEach(0..<10) { i in
                        NavigationLink(destination: ServicesView().navigationTitle("Services"), label: {
                            RoundedRectangle(cornerRadius: 15)
                                .foregroundStyle(.thinMaterial)
                                .frame(height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                                .overlay {Text("Test").font(.largeTitle).foregroundStyle(.primary)}
                                .scrollTransition {content, phase in content
                                        .opacity(phase.isIdentity ? 1 : 0)
                                        //.rotation3DEffect(
                                        //    .degrees(phase.value * -90),axis: (x: 1.0, y: 0.0, z: 0.0), anchor: phase.value < 0 ? .bottom : .top
                                        //)
                                        //.offset(y: phase.value * -50)
                                }
                        })
                        .scrollTargetLayout()
                    }
                }
                .scrollTargetBehavior(.viewAligned)
                .padding(40)
            }
        }
    }
}


struct ServicesView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundStyle(Color(.green).gradient)
                .ignoresSafeArea()
            ScrollView {
                VStack {
                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                        .frame(width: 250, height: 100)
                }
            }
        }
    }
}


#Preview {
    DevicesView()
}
