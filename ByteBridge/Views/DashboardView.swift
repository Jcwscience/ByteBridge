//
//  DashboardView.swift
//  ByteBridge
//
//  Created by John on 9/28/23.
//

import SwiftUI

struct DashboardView: View {
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    
                }, label: {
                    AddWidgetView()
                })
                Spacer()
                WidgetView()
                Spacer()
                WidgetView()
                Spacer()
            }
            Spacer()
        }
        .padding([.leading, .trailing], 20)
        .padding(.top, 30.0)
    }
}

struct AddWidgetView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/)
            .stroke(style: .init(lineWidth: 3))
            .overlay(content: {
                Image(systemName: "plus.app.fill")
                    .font(.largeTitle)
            })
            .frame(width: 100, height: 100)
    }
}

struct WidgetView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/)
            .foregroundStyle(Color(.red).gradient)
            
            .overlay(content: {
                GaugeView(value: 0.7)
            })
            .frame(width: 100, height: 100)
    }
}

#Preview {
    DashboardView()
}
