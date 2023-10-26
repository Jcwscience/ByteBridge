//
//  HapticManager.swift
//  ByteBridge
//
//  Created by John Wallace on 10/5/23.
//

import Foundation
import CoreHaptics
import UIKit

class HapticManager {
    let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
    func impact() {
        impactFeedback.impactOccurred()
    }
}
