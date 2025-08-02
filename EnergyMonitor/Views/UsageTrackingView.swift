//
//  UsageTrackingView.swift
//  EnergyMonitor
//
//  Created by Mohamed Hamdi on 02/08/2025.
//

import SwiftUI
import Charts

struct UsageTrackingView: View {
    @EnvironmentObject var localizationManager: LocalizationManager
    @StateObject private var energyViewModel = EnergyReadingViewModel()
    @State private var showingAddReading = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Add Reading Button
                    Button(action: { showingAddReading = true }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text(localizationManager.localizedString("add_reading"))
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(12)
                    }
                    
                    // Consumption Chart
                    ConsumptionChartView(readings: energyViewModel.readings)
                    
                    // Bill Estimate
                    BillEstimateView()
                    
                    // Recent Readings List
                    RecentReadingsView()
                }
                .padding()
            }
            .navigationTitle(localizationManager.localizedString("usage"))
            .sheet(isPresented: $showingAddReading) {
                AddReadingView()
            }
            .onAppear {
                energyViewModel.fetchReadings()
            }
            .environmentObject(energyViewModel)
        }
    }
}

struct ConsumptionChartView: View {
    let readings: [EnergyReading]
    @EnvironmentObject var localizationManager: LocalizationManager
    
    var chartData: [ChartDataPoint] {
        let sortedReadings = readings.sorted { $0.timestamp < $1.timestamp }
        return sortedReadings.enumerated().compactMap { index, reading in
            if index == 0 { return nil }
            let previousReading = sortedReadings[index - 1]
            let consumption = reading.reading - previousReading.reading
            return ChartDataPoint(
                date: reading.timestamp,
                consumption: max(0, consumption)
            )
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(localizationManager.localizedString("consumption_chart"))
                .font(.headline)
            
            if !chartData.isEmpty {
                Chart(chartData) { dataPoint in
                    LineMark(
                        x: .value("Date", dataPoint.date),
                        y: .value("Consumption", dataPoint.consumption)
                    )
                    .foregroundStyle(.green)
                }
                .frame(height: 200)
                .chartYAxis {
                    AxisMarks(position: .leading)
                }
                .chartXAxis {
                    AxisMarks(values: .stride(by: .day, count: 7)) { _ in
                        AxisGridLine()
                        AxisValueLabel(format: .dateTime.month().day())
                    }
                }
            } else {
                Text("No consumption data available")
                    .foregroundColor(.secondary)
                    .frame(height: 200)
                    .frame(maxWidth: .infinity)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct ChartDataPoint: Identifiable {
    let id = UUID()
    let date: Date
    let consumption: Double
}

struct BillEstimateView: View {
    @EnvironmentObject var localizationManager: LocalizationManager
    @EnvironmentObject var energyViewModel: EnergyReadingViewModel
    
    // Sample tariff rates for different regions
    private let tariffRates: [String: Double] = [
        "Saudi Arabia": 0.30,
        "UAE": 0.38,
        "Kuwait": 0.02,
        "Egypt": 0.15,
        "Jordan": 0.20
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(localizationManager.localizedString("bill_estimate"))
                .font(.headline)
            
            let consumption = energyViewModel.calculateMonthlyConsumption()
            let currentRegion = UserDefaults.standard.string(forKey: "selectedRegion") ?? "Saudi Arabia"
            let tariffRate = tariffRates[currentRegion] ?? 0.30
            let estimatedBill = consumption * tariffRate
            
            VStack(spacing: 8) {
                HStack {
                    Text("Monthly Consumption:")
                    Spacer()
                    Text("\(Int(consumption)) kWh")
                        .fontWeight(.semibold)
                }
                
                HStack {
                    Text("Tariff Rate:")
                    Spacer()
                    Text("\(tariffRate, specifier: "%.2f") SAR/kWh")
                        .fontWeight(.semibold)
                }
                
                Divider()
                
                HStack {
                    Text("Estimated Bill:")
                        .fontWeight(.bold)
                    Spacer()
                    Text("\(estimatedBill, specifier: "%.2f") SAR")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct RecentReadingsView: View {
    @EnvironmentObject var localizationManager: LocalizationManager
    @EnvironmentObject var energyViewModel: EnergyReadingViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Recent Readings")
                    .font(.headline)
                Spacer()
                Button(localizationManager.localizedString("export_data")) {
                    exportData()
                }
                .font(.caption)
                .foregroundColor(.blue)
            }
            
            if energyViewModel.readings.isEmpty {
                Text("No readings available")
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, minHeight: 100)
            } else {
                LazyVStack(spacing: 8) {
                    ForEach(Array(energyViewModel.readings.prefix(10))) { reading in
                        ReadingRowView(reading: reading)
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    private func exportData() {
        // Implementation for data export
        let csvContent = generateCSV()
        shareCSV(content: csvContent)
    }
    
    private func generateCSV() -> String {
        var csv = "Date,Reading,Type,Method\n"
        for reading in energyViewModel.readings {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            let dateString = dateFormatter.string(from: reading.timestamp)
            csv += "\(dateString),\(reading.reading),\(reading.meterType.rawValue),\(reading.readingMethod.rawValue)\n"
        }
        return csv
    }
    
    private func shareCSV(content: String) {
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("energy_readings.csv")
        do {
            try content.write(to: tempURL, atomically: true, encoding: .utf8)
            let activityVC = UIActivityViewController(activityItems: [tempURL], applicationActivities: nil)
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                window.rootViewController?.present(activityVC, animated: true)
            }
        } catch {
            print("Error exporting CSV: \(error)")
        }
    }
}

struct ReadingRowView: View {
    let reading: EnergyReading
    @EnvironmentObject var energyViewModel: EnergyReadingViewModel
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("\(reading.reading, specifier: "%.1f") kWh")
                    .fontWeight(.semibold)
                Text(reading.timestamp, style: .date)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Image(systemName: reading.readingMethod == .ocr ? "camera.fill" : "pencil")
                    .foregroundColor(.blue)
                Text(reading.meterType.rawValue.capitalized)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
        .swipeActions(edge: .trailing) {
            Button("Delete", role: .destructive) {
                energyViewModel.deleteReading(reading)
            }
        }
    }
}
