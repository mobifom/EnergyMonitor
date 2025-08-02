//
//  CSVExporter.swift
//  EnergyMonitor
//
//  Created by Mohamed Hamdi on 02/08/2025.
//

import Foundation

struct CSVExporter {
    static func generateCSV(from readings: [EnergyReading]) -> String {
        var csv = "Date,Time,Reading (kWh),Meter Type,Reading Method,Notes\n"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        
        let timeFormatter = DateFormatter()
        timeFormatter.timeStyle = .short
        
        for reading in readings.sorted(by: { $0.timestamp < $1.timestamp }) {
            let dateString = dateFormatter.string(from: reading.timestamp)
            let timeString = timeFormatter.string(from: reading.timestamp)
            let notes = reading.notes?.replacingOccurrences(of: ",", with: ";") ?? ""
            
            csv += "\(dateString),\(timeString),\(reading.reading),\(reading.meterType.rawValue),\(reading.readingMethod.rawValue),\(notes)\n"
        }
        
        return csv
    }
    
    static func generateConsumptionCSV(from readings: [EnergyReading]) -> String {
        var csv = "Date,Daily Consumption (kWh),Cumulative Reading (kWh)\n"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        
        let sortedReadings = readings.sorted { $0.timestamp < $1.timestamp }
        
        for (index, reading) in sortedReadings.enumerated() {
            let dateString = dateFormatter.string(from: reading.timestamp)
            
            if index == 0 {
                csv += "\(dateString),0,\(reading.reading)\n"
            } else {
                let previousReading = sortedReadings[index - 1]
                let consumption = max(0, reading.reading - previousReading.reading)
                csv += "\(dateString),\(consumption),\(reading.reading)\n"
            }
        }
        
        return csv
    }
}
