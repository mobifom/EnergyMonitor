//
//  EnergyTip.swift
//  EnergyMonitor
//
//  Created by Mohamed Hamdi on 02/08/2025.
//

import Foundation

struct EnergyTip: Identifiable, Codable {
    let id = UUID()
    let titleAR: String
    let titleEN: String
    let descriptionAR: String
    let descriptionEN: String
    let category: TipCategory
    let estimatedSavings: String
    let difficulty: Difficulty
    let icon: String
    
    enum TipCategory: String, CaseIterable, Codable {
        case cooling = "cooling"
        case heating = "heating"
        case lighting = "lighting"
        case appliances = "appliances"
        case general = "general"
    }
    
    enum Difficulty: String, CaseIterable, Codable {
        case easy = "easy"
        case medium = "medium"
        case hard = "hard"
    }
}
