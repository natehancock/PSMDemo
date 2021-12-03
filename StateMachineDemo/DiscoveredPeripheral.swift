//
//  DiscoveredPeripheral.swift
//  StateMachineDemo
//
//  Created by Nate Hancock on 12/2/21.
//

import Foundation


struct DiscoveredPeripheral: Codable {
    let name: String
    
    
    static func random() -> DiscoveredPeripheral {
        return randomPeripheral()
    }
}

extension DiscoveredPeripheral: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
    
    static func == (lhs: DiscoveredPeripheral, rhs: DiscoveredPeripheral) -> Bool {
        lhs.name == rhs.name
    }
    static private func randomPeripheral() -> DiscoveredPeripheral {
        let peripheral = DiscoveredPeripheral(name: randomString(length: 5))
        return peripheral
    }

    static private func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
}
