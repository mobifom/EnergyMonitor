//
//  EnergyReading.swift
//  EnergyMonitor
//
//  Created by Mohamed Hamdi on 02/08/2025.
//

import Foundation
import FirebaseFirestore

struct EnergyReading: Identifiable, Codable {
    @DocumentID var id: String?
    let reading: Double
    let timestamp: Date
    let meterType: MeterType
    let readingMethod: ReadingMethod
    let notes: String?
    let imageURL: String?
    
    enum MeterType: String, CaseIterable, Codable {
        case electricity = "electricity"
        case water = "water"
        case gas = "gas"
    }
    
    enum ReadingMethod: String, CaseIterable, Codable {
        case manual = "manual"
        case ocr = "ocr"
        case smart = "smart"
    }
}
