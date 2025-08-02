//
//  TariffCalculator.swift
//  EnergyMonitor
//
//  Created by Mohamed Hamdi on 02/08/2025.
//

import Foundation

struct TariffCalculator {
    private static let tariffRates: [String: [TariffTier]] = [
        "Saudi Arabia": [
            TariffTier(from: 0, to: 6000, rate: 0.18),
            TariffTier(from: 6001, to: Double.infinity, rate: 0.30)
        ],
        "UAE": [
            TariffTier(from: 0, to: 2000, rate: 0.23),
            TariffTier(from: 2001, to: 4000, rate: 0.28),
            TariffTier(from: 4001, to: 6000, rate: 0.32),
            TariffTier(from: 6001, to: Double.infinity, rate: 0.38)
        ],
        "Kuwait": [
            TariffTier(from: 0, to: Double.infinity, rate: 0.02)
        ],
        "Egypt": [
            TariffTier(from: 0, to: 50, rate: 0.48),
            TariffTier(from: 51, to: 100, rate: 0.58),
            TariffTier(from: 101, to: 200, rate: 0.67),
            TariffTier(from: 201, to: 350, rate: 0.78),
            TariffTier(from: 351, to: 650, rate: 0.90),
            TariffTier(from: 651, to: 1000, rate: 1.35),
            TariffTier(from: 1001, to: Double.infinity, rate: 1.45)
        ],
        "Jordan": [
            TariffTier(from: 0, to: 160, rate: 0.068),
            TariffTier(from: 161, to: 300, rate: 0.132),
            TariffTier(from: 301, to: 500, rate: 0.198),
            TariffTier(from: 501, to: 600, rate: 0.264),
            TariffTier(from: 601, to: 750, rate: 0.346),
            TariffTier(from: 751, to: 1000, rate: 0.396),
            TariffTier(from: 1001, to: Double.infinity, rate: 0.446)
        ]
    ]
    
    static func calculateBill(consumption: Double, region: String) -> Double {
        guard let tiers = tariffRates[region] else {
            // Default to Saudi Arabia rates
            return calculateBill(consumption: consumption, region: "Saudi Arabia")
        }
        
        var totalCost = 0.0
        var remainingConsumption = consumption
        
        for tier in tiers {
            let tierConsumption = min(remainingConsumption, tier.to - tier.from + 1)
            if tierConsumption > 0 {
                totalCost += tierConsumption * tier.rate
                remainingConsumption -= tierConsumption
            }
            
            if remainingConsumption <= 0 {
                break
            }
        }
        
        return totalCost
    }
    
    static func getAverageTariffRate(region: String) -> Double {
        guard let tiers = tariffRates[region] else {
            return 0.30 // Default Saudi rate
        }
        
        // Return weighted average of first few tiers for typical consumption
        let typicalConsumption = 1000.0
        let bill = calculateBill(consumption: typicalConsumption, region: region)
        return bill / typicalConsumption
    }
}

struct TariffTier {
    let from: Double
    let to: Double
    let rate: Double
}
