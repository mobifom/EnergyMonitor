//
//  ACRecommendation.swift
//  EnergyMonitor
//
//  Created by Mohamed Hamdi on 02/08/2025.
//

import Foundation

struct ACRecommendation {
    let mode: ACMode
    let temperature: Int
    let reason: String
    let estimatedSavings: String
    
    enum ACMode: String, CaseIterable {
        case off = "off"
        case fan = "fan"
        case cool = "cool"
        case eco = "eco"
        case sleep = "sleep"
    }
}
