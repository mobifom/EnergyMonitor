//
//  Double+Extensions.swift
//  EnergyMonitor
//
//  Created by Mohamed Hamdi on 02/08/2025.
//

import Foundation

extension Double {
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    
    var formattedAsEnergy: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 1
        formatter.minimumFractionDigits = 0
        return "\(formatter.string(from: NSNumber(value: self)) ?? "0") kWh"
    }
    
    var formattedAsCurrency: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = UserDefaults.standard.string(forKey: "selectedCurrency") ?? "SAR"
        return formatter.string(from: NSNumber(value: self)) ?? "0"
    }
}
