//
//  Widgets.swift
//  ByteBridge
//
//  Created by John on 9/27/23.
//

import Foundation
import SwiftUI

struct GaugeView: View {
    var value: Double  // This will be in the range [0, 1], where 0 is the minimum, and 1 is the maximum
    
    var body: some View {
        ZStack {
            // Gauge Background
            Circle()
                .stroke(Color.gray, lineWidth: 20)
            
            // Needle
            Rectangle()
                .fill(Color.blue)
                .frame(width: 10, height: 150) // Adjust size as needed
                .offset(y: -75) // Move it up to the edge of the circle
                .rotationEffect(.degrees(-120 + 240 * value)) // Convert the [0,1] value to [-120,120] degrees
        }
    }
}
