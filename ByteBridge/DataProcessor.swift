//
//  DataProcessor.swift
//  ByteBridge
//
//  Created by John on 9/26/23.
//

import Foundation

enum ProcessedData {
    case string(String)
    case integer(Int)
    case none
}

func processData(byteArray: [UInt8]) -> ProcessedData {
    guard !byteArray.isEmpty else {
        print("Error: Byte array is empty.")
        return .none
    }
    
    let firstByte = byteArray[0]
    let remainingBytes = Array(byteArray.dropFirst())

    switch firstByte {
    case 1:
        if let stringData = Data(remainingBytes).utf8String {
            return .string(stringData)
        } else {
            print("Error: Unable to decode string from byte array.")
            return .none
        }
    case 2:
        if remainingBytes.count >= MemoryLayout<Int>.size {
            let intValue = remainingBytes.withUnsafeBytes { pointer -> Int in
                pointer.load(as: Int.self)
            }
            return .integer(intValue)
        } else {
            print("Error: Not enough bytes to form an integer.")
            return .none
        }
    default:
        print("Error: Unknown first byte value.")
        return .none
    }
}

// Helper extension for Data to String conversion
extension Data {
    var utf8String: String? {
        String(data: self, encoding: .utf8)
    }
}
