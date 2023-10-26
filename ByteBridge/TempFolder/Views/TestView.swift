//
//  TestView.swift
//  ByteBridge
//
//  Created by John Wallace on 10/5/23.
//

import SwiftUI

struct TestView: View {
    var body: some View {
        NavigationStack {
            RoundedRectangle(cornerRadius: 15, style: .continuous)
                .foregroundStyle(Color(.gray))
                .padding()
                .frame(height: 250)
            NavigationLink(destination: ItemView(), label: {
                Text("Link")
            })
        }
    }
}


struct ItemView: View {
    var body: some View {
        Text("Items")
    }
}



#Preview {
    TestView()
}
