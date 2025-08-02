//
//  AddReadingView.swift
//  EnergyMonitor
//
//  Created by Mohamed Hamdi on 02/08/2025.
//

import SwiftUI

struct AddReadingView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var localizationManager: LocalizationManager
    @EnvironmentObject var energyViewModel: EnergyReadingViewModel
    
    @State private var reading: String = ""
    @State private var selectedMeterType: EnergyReading.MeterType = .electricity
    @State private var selectedDate = Date()
    @State private var notes: String = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text(localizationManager.localizedString("meter_reading"))) {
                    TextField("Enter reading", text: $reading)
                        .keyboardType(.decimalPad)
                    
                    Picker("Meter Type", selection: $selectedMeterType) {
                        ForEach(EnergyReading.MeterType.allCases, id: \.self) { type in
                            Text(type.rawValue.capitalized).tag(type)
                        }
                    }
                    
                    DatePicker("Date", selection: $selectedDate, displayedComponents: .date)
                }
                
                Section(header: Text("Notes (Optional)")) {
                    TextField("Add notes", text: $notes, axis: .vertical)
                        .lineLimit(3...6)
                }
            }
            .navigationTitle(localizationManager.localizedString("add_reading"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(localizationManager.localizedString("cancel")) {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(localizationManager.localizedString("save")) {
                        saveReading()
                    }
                    .disabled(reading.isEmpty)
                }
            }
            .alert("Error", isPresented: $showingAlert) {
                Button("OK") { }
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    private func saveReading() {
        guard let readingValue = Double(reading) else {
            alertMessage = "Please enter a valid number"
            showingAlert = true
            return
        }
        
        let newReading = EnergyReading(
            reading: readingValue,
            timestamp: selectedDate,
            meterType: selectedMeterType,
            readingMethod: .manual,
            notes: notes.isEmpty ? nil : notes,
            imageURL: nil
        )
        
        energyViewModel.addReading(newReading)
        presentationMode.wrappedValue.dismiss()
    }
}
