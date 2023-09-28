//
//  DevicesView.swift
//  ByteBridge
//
//  Created by John on 9/28/23.
//

import SwiftUI

struct DevicesView: View {
    var body: some View {
        VStack {
            ZStack {
                Rectangle()
                    .frame(width: 300, height: 50)
                    .cornerRadius(10.0)
                    .foregroundStyle(Color(.green))
                HStack {
                    Image(systemName: "wave.3.left")
                    Text("Connect")
                    Image(systemName: "wave.3.right")
                }
            }
            Spacer()
        }
        .padding(.top, 30.0)
    }
}

#Preview {
    DevicesView()
}
