//
//  DataExportView.swift
//  EnergyMonitor
//
//  Created by Mohamed Hamdi on 02/08/2025.
//

import SwiftUI

struct DataExportView: View {
    @EnvironmentObject var localizationManager: LocalizationManager
    @StateObject private var energyViewModel = EnergyReadingViewModel()
    @State private var selectedFormat: ExportFormat = .csv
    @State private var selectedDateRange: DateRange = .allTime
    @State private var isExporting = false
    
    enum ExportFormat: String, CaseIterable {
        case csv = "CSV"
        case excel = "Excel"
        case pdf = "PDF"
    }
    
    enum DateRange: String, CaseIterable {
        case lastWeek = "Last Week"
        case lastMonth = "Last Month"
        case lastYear = "Last Year"
        case allTime = "All Time"
    }
    
    var body: some View {
        Form {
            Section(header: Text("Export Format")) {
                Picker("Format", selection: $selectedFormat) {
                    ForEach(ExportFormat.allCases, id: \.self) { format in
                        Text(format.rawValue).tag(format)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            
            Section(header: Text("Date Range")) {
                Picker("Range", selection: $selectedDateRange) {
                    ForEach(DateRange.allCases, id: \.self) { range in
                        Text(range.rawValue).tag(range)
                    }
                }
            }
            
            Section(header: Text("Data Summary")) {
                HStack {
                    Text("Total Readings:")
                    Spacer()
                    Text("\(filteredReadings.count)")
                        .fontWeight(.semibold)
                }
                
                HStack {
                    Text("Date Range:")
                    Spacer()
                    VStack(alignment: .trailing) {
                        if let firstDate = filteredReadings.last?.timestamp,
                           let lastDate = filteredReadings.first?.timestamp {
                            Text(firstDate, style: .date)
                            Text("to")
                                .font(.caption)
                            Text(lastDate, style: .date)
                        } else {
                            Text("No data")
                        }
                    }
                    .font(.caption)
                    .foregroundColor(.secondary)
                }
            }
            
            Section {
                Button(action: exportData) {
                    HStack {
                        if isExporting {
                            ProgressView()
                                .scaleEffect(0.8)
                        }
                        Text("Export Data")
                        Spacer()
                        Image(systemName: "square.and.arrow.up")
                    }
                }
                .disabled(isExporting || filteredReadings.isEmpty)
            }
        }
        .navigationTitle("Export Data")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            energyViewModel.fetchReadings()
        }
    }
    
    private var filteredReadings: [EnergyReading] {
        let calendar = Calendar.current
        let now = Date()
        
        switch selectedDateRange {
        case .lastWeek:
            let weekAgo = calendar.date(byAdding: .weekOfYear, value: -1, to: now) ?? now
            return energyViewModel.readings.filter { $0.timestamp >= weekAgo }
        case .lastMonth:
            let monthAgo = calendar.date(byAdding: .month, value: -1, to: now) ?? now
            return energyViewModel.readings.filter { $0.timestamp >= monthAgo }
        case .lastYear:
            let yearAgo = calendar.date(byAdding: .year, value: -1, to: now) ?? now
            return energyViewModel.readings.filter { $0.timestamp >= yearAgo }
        case .allTime:
            return energyViewModel.readings
        }
    }
    
    private func exportData() {
        isExporting = true
        
        DispatchQueue.global(qos: .userInitiated).async {
            let content = generateExportContent()
            
            DispatchQueue.main.async {
                shareContent(content: content)
                isExporting = false
            }
        }
    }
    
    private func generateExportContent() -> String {
        switch selectedFormat {
        case .csv:
            return generateCSV()
        case .excel:
            return generateCSV() // For simplicity, using CSV format
        case .pdf:
            return generateCSV() // Would need proper PDF generation
        }
    }
    
    private func generateCSV() -> String {
        var csv = "Date,Reading (kWh),Meter Type,Reading Method,Notes\n"
        
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        
        for reading in filteredReadings.reversed() {
            let dateString = formatter.string(from: reading.timestamp)
            let notes = reading.notes?.replacingOccurrences(of: ",", with: ";") ?? ""
            csv += "\(dateString),\(reading.reading),\(reading.meterType.rawValue),\(reading.readingMethod.rawValue),\(notes)\n"
        }
        
        return csv
    }
    
    private func shareContent(content: String) {
        let fileName = "energy_readings_\(selectedDateRange.rawValue.lowercased().replacingOccurrences(of: " ", with: "_")).\(selectedFormat.rawValue.lowercased())"
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
        
        do {
            try content.write(to: tempURL, atomically: true, encoding: .utf8)
            
            let activityVC = UIActivityViewController(activityItems: [tempURL], applicationActivities: nil)
            
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                window.rootViewController?.present(activityVC, animated: true)
            }
        } catch {
            print("Error exporting data: \(error)")
        }
    }
}
