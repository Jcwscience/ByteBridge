//
//  DevicesView.swift
//  ByteBridge
//
//  Created by John on 9/28/23.
//

import SwiftUI
import CoreBluetooth
import NavigationTransitions
import CoreHaptics

struct DevicesView: View {
    @StateObject var bluetoothManager = BluetoothManager()
    @State var showDevicePicker = false
    @State var savedDevices: [CBPeripheral] = []
    let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
    var body: some View {
        NavigationStack {
            ZStack {
                Rectangle()
                    .foregroundStyle(Color(.green).gradient)
                    .ignoresSafeArea()
                RoundedRectangle(cornerRadius: 15, style: .continuous)
                    .foregroundStyle(.ultraThinMaterial)
                    .padding()
                ScrollView {
                    ForEach(0..<10) { i in
                        NavigationLink(destination: ServicesView(), label: {
                            RoundedRectangle(cornerRadius: 15)
                                .foregroundStyle(.ultraThinMaterial)
                                .frame(height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                                .overlay {Text("Test").font(.largeTitle).foregroundStyle(Color(.black))}
                                .scrollTransition {content, phase in content
                                        .opacity(phase.isIdentity ? 1 : 0)
                                        .rotation3DEffect(
                                            .degrees(phase.value * -90),axis: (x: 1.0, y: 0.0, z: 0.0), anchor: phase.value < 0 ? .bottom : .top
                                        )
                                        //.offset(y: phase.value * -50)
                                }
                        })
                    }
                }
                .padding(40)
            }
        }
    }
}

struct DeviceView: View {
    var deviceName = ""
    var deviceUUID = ""
    var body: some View {
        Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
            RoundedRectangle(cornerRadius: 15, style: .continuous)
                .foregroundStyle(.ultraThinMaterial)
                .overlay(RoundedRectangle(cornerRadius: 15, style: .continuous).strokeBorder(.thinMaterial, lineWidth: 3, antialiased: true))
                .overlay(alignment: .topLeading, content: {Text("Pi-Pico").font(.title).foregroundStyle(Color(.black)).padding(.top, 10).padding(.leading, 15)})
                .overlay(alignment: .bottomLeading, content: {Text("59ecc024-8316-4d2b-ae84-976e08bed3dd").font(.subheadline).foregroundStyle(Color(.black)).padding(.bottom, 10).padding(.leading, 15)})
                .overlay(alignment: .trailing, content: {Image(systemName: "chevron.forward").font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/).foregroundStyle(Color(.black)).padding(20)})
                .frame(height: 75)
        })
    }
}


struct ServicesView: View {
    var body: some View {
        ScrollView {
            VStack {
                RoundedRectangle(cornerRadius: 15, style: .continuous)
                    .frame(width: 250, height: 100)
            }
        }
    }
}


#Preview {
    ContentView()
}
