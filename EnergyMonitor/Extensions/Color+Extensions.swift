//
//  Color+Extensions.swift
//  EnergyMonitor
//
//  Created by Mohamed Hamdi on 02/08/2025.
//

import SwiftUI

extension Color {
    static let energyGreen = Color(red: 0.2, green: 0.7, blue: 0.3)
    static let energyBlue = Color(red: 0.2, green: 0.6, blue: 0.9)
    static let energyOrange = Color(red: 1.0, green: 0.6, blue: 0.2)
    static let energyRed = Color(red: 0.9, green: 0.3, blue: 0.3)
    
    // Custom colors for different energy consumption levels
    static func energyColor(for consumption: Double, max: Double) -> Color {
        let percentage = consumption / max
        
        if percentage <= 0.5 {
            return .energyGreen
        } else if percentage <= 0.75 {
            return .energyOrange
        } else {
            return .energyRed
        }
    }
}
