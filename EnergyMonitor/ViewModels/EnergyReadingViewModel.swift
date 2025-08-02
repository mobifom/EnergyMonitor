//
//  EnergyReadingViewModel.swift
//  EnergyMonitor
//
//  Created by Mohamed Hamdi on 02/08/2025.
//

import Foundation
import FirebaseFirestore
import Combine

class EnergyReadingViewModel: ObservableObject {
    @Published var readings: [EnergyReading] = []
    @Published var isLoading = false
    @Published var errorMessage = ""
    
    private let db = Firestore.firestore()
    private var cancellables = Set<AnyCancellable>()
    
    func fetchReadings() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        isLoading = true
        
        db.collection("users").document(userId).collection("readings")
            .order(by: "timestamp", descending: true)
            .addSnapshotListener { [weak self] snapshot, error in
                DispatchQueue.main.async {
                    self?.isLoading = false
                    
                    if let error = error {
                        self?.errorMessage = error.localizedDescription
                        return
                    }
                    
                    guard let documents = snapshot?.documents else { return }
                    
                    self?.readings = documents.compactMap { document in
                        try? document.data(as: EnergyReading.self)
                    }
                }
            }
    }
    
    func addReading(_ reading: EnergyReading) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        do {
            try db.collection("users").document(userId).collection("readings").addDocument(from: reading)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func deleteReading(_ reading: EnergyReading) {
        guard let userId = Auth.auth().currentUser?.uid,
              let documentId = reading.id else { return }
        
        db.collection("users").document(userId).collection("readings").document(documentId).delete()
    }
    
    func calculateMonthlyConsumption() -> Double {
        let calendar = Calendar.current
        let currentMonth = calendar.component(.month, from: Date())
        let currentYear = calendar.component(.year, from: Date())
        
        let monthlyReadings = readings.filter { reading in
            let readingMonth = calendar.component(.month, from: reading.timestamp)
            let readingYear = calendar.component(.year, from: reading.timestamp)
            return readingMonth == currentMonth && readingYear == currentYear
        }
        
        guard monthlyReadings.count >= 2 else { return 0 }
        
        let sortedReadings = monthlyReadings.sorted { $0.timestamp < $1.timestamp }
        let firstReading = sortedReadings.first?.reading ?? 0
        let lastReading = sortedReadings.last?.reading ?? 0
        
        return lastReading - firstReading
    }
    
    func estimateMonthlyBill(tariffRate: Double) -> Double {
        let consumption = calculateMonthlyConsumption()
        return consumption * tariffRate
    }
}
