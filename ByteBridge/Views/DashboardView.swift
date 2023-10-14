//
//  DashboardView.swift
//  ByteBridge
//
//  Created by John on 9/28/23.
//

import SwiftUI
import CoreBluetooth

struct DashboardView: View {
    @StateObject var bluetoothManager: BluetoothManager
    @State var activeWidgets: [WidgetConfig] = []
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundStyle(Color(.gray).gradient)
                .ignoresSafeArea()
            ScrollView {
                LazyVGrid(columns: columns) {
                    Button(action: {
                        let newWidget = WidgetConfig()
                        activeWidgets.append(newWidget)
                    }, label: {
                        AddWidgetView()
                    })
                    ForEach(activeWidgets, id: \.uuid) { config in
                        TestWidgetView()
                    }
                }
            }
        }
    }
}

struct AddWidgetView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/, style: .circular)
            .stroke(style: .init(lineWidth: 3))
            .overlay(content: {
                Image(systemName: "plus.app.fill")
                    .font(.largeTitle)
            })
            .frame(width: 150, height: 150)
    }
}

struct TestWidgetView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/)
            .foregroundStyle(.thinMaterial)
            
            .overlay(content: {
                GaugeView(value: 0.5)
            })
            .frame(width: 150, height: 150)
    }
}



struct WidgetView: View {
    @State var value:Data
    var body: some View {
        RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/)
            .foregroundStyle(.thinMaterial)
            
            .overlay(content: {
                GaugeView(value: (Double(String(data: value, encoding: .utf8) ?? "0") ?? 0.0) / 100)
            })
            .frame(width: 150, height: 150)
    }
}


class WidgetConfig: ObservableObject {
    let uuid: UUID
    @Published var dataSource: BluetoothCharacteristic?
    
    init(uuid: UUID = UUID(), dataSource:BluetoothCharacteristic? = nil) {
        self.uuid = uuid
        self.dataSource = dataSource
    }
}



#Preview {
    ContentView()
}
