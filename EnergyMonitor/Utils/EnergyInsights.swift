//
//  EnergyInsights.swift
//  EnergyMonitor
//
//  Created by Mohamed Hamdi on 02/08/2025.
//

import Foundation

struct EnergyInsights {
    static func generateInsights(from readings: [EnergyReading]) -> [EnergyInsight] {
        var insights: [EnergyInsight] = []
        
        // Monthly comparison
        if let monthlyComparison = generateMonthlyComparison(readings: readings) {
            insights.append(monthlyComparison)
        }
        
        // Daily pattern analysis
        if let dailyPattern = analyzeDailyPattern(readings: readings) {
            insights.append(dailyPattern)
        }
        
        // Efficiency insights
        insights.append(contentsOf: generateEfficiencyInsights(readings: readings))
        
        return insights
    }
    
    private static func generateMonthlyComparison(readings: [EnergyReading]) -> EnergyInsight? {
        let calendar = Calendar.current
        let now = Date()
        
        guard let lastMonth = calendar.date(byAdding: .month, value: -1, to: now) else { return nil }
        
        let thisMonthReadings = readings.filter { calendar.isDate($0.timestamp, equalTo: now, toGranularity: .month) }
        let lastMonthReadings = readings.filter { calendar.isDate($0.timestamp, equalTo: lastMonth, toGranularity: .month) }
        
        let thisMonthConsumption = calculateConsumption(readings: thisMonthReadings)
        let lastMonthConsumption = calculateConsumption(readings: lastMonthReadings)
        
        let difference = thisMonthConsumption - lastMonthConsumption
        let percentageChange = lastMonthConsumption > 0 ? (difference / lastMonthConsumption) * 100 : 0
        
        let message: String
        let type: EnergyInsight.InsightType
        
        if percentageChange > 10 {
            message = "Your energy consumption increased by \(Int(percentageChange))% compared to last month. Consider reviewing your usage patterns."
            type = .warning
        } else if percentageChange < -10 {
            message = "Great job! You reduced your energy consumption by \(Int(abs(percentageChange)))% compared to last month."
            type = .success
        } else {
            message = "Your energy consumption is stable compared to last month."
            type = .info
        }
        
        return EnergyInsight(
            title: "Monthly Comparison",
            message: message,
            type: type,
            actionable: percentageChange > 10
        )
    }
    
    private static func analyzeDailyPattern(readings: [EnergyReading]) -> EnergyInsight? {
        // Analyze consumption patterns throughout the day
        let recentReadings = readings.filter { $0.timestamp > Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date() }
        
        guard !recentReadings.isEmpty else { return nil }
        
        let hourlyConsumption = Dictionary(grouping: recentReadings) { reading in
            Calendar.current.component(.hour, from: reading.timestamp)
        }
        
        let peakHour = hourlyConsumption.max { a, b in
            calculateConsumption(readings: a.value) < calculateConsumption(readings: b.value)
        }?.key ?? 12
        
        return EnergyInsight(
            title: "Usage Pattern",
            message: "Your peak energy usage typically occurs around \(peakHour):00. Consider shifting some activities to off-peak hours.",
            type: .info,
            actionable: true
        )
    }
    
    private static func generateEfficiencyInsights(readings: [EnergyReading]) -> [EnergyInsight] {
        var insights: [EnergyInsight] = []
        
        let totalConsumption = calculateConsumption(readings: readings)
        
        if totalConsumption > 1000 {
            insights.append(EnergyInsight(
                title: "High Consumption",
                message: "Your monthly consumption is above average. Check AC settings and consider energy-efficient appliances.",
                type: .warning,
                actionable: true
            ))
        }
        
        // Check for unusual spikes
        let dailyConsumptions = calculateDailyConsumptions(readings: readings)
        let averageDaily = dailyConsumptions.reduce(0, +) / Double(dailyConsumptions.count)
        let spikes = dailyConsumptions.filter { $0 > averageDaily * 1.5 }
        
        if !spikes.isEmpty {
            insights.append(EnergyInsight(
                title: "Usage Spikes",
                message: "Detected \(spikes.count) days with unusually high consumption. Review your energy usage on those days.",
                type: .warning,
                actionable: true
            ))
        }
        
        return insights
    }
    
    private static func calculateConsumption(readings: [EnergyReading]) -> Double {
        let sortedReadings = readings.sorted { $0.timestamp < $1.timestamp }
        guard let first = sortedReadings.first, let last = sortedReadings.last else { return 0 }
        return max(0, last.reading - first.reading)
    }
    
    private static func calculateDailyConsumptions(readings: [EnergyReading]) -> [Double] {
        let groupedByDay = Dictionary(grouping: readings) { reading in
            Calendar.current.startOfDay(for: reading.timestamp)
        }
        
        return groupedByDay.compactMap { _, dayReadings in
            calculateConsumption(readings: dayReadings)
        }
    }
}

struct EnergyInsight {
    let title: String
    let message: String
    let type: InsightType
    let actionable: Bool
    
    enum InsightType {
        case success
        case warning
        case info
        
        var color: Color {
            switch self {
            case .success: return .green
            case .warning: return .orange
            case .info: return .blue
            }
        }
        
        var icon: String {
            switch self {
            case .success: return "checkmark.circle.fill"
            case .warning: return "exclamationmark.triangle.fill"
            case .info: return "info.circle.fill"
            }
        }
    }
}
