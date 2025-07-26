//
//  Item.swift
//  EnergyMonitor
//
//  Created by Mohamed Hamdi on 27/07/2025.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
