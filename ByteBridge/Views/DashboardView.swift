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
                AddWidgetView()
                Spacer()
                AddWidgetView()
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
        ZStack {
            RoundedRectangle(cornerSize: CGSize(width: 20, height: 20), style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/)
                .stroke(style: StrokeStyle(lineWidth: 3))
                .foregroundStyle(Color(.gray))
                .frame(width: 100, height: 100)
            Image(systemName: "plus.app.fill")
                .resizable()
                .frame(width: 50, height: 50)
        }
    }
}

#Preview {
    DashboardView()
}
