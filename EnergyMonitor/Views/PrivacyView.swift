//
//  PrivacyView.swift
//  EnergyMonitor
//
//  Created by Mohamed Hamdi on 02/08/2025.
//

import SwiftUI

struct PrivacyView: View {
    @EnvironmentObject var localizationManager: LocalizationManager
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Privacy Policy")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Group {
                    PrivacySection(
                        title: "Data Collection",
                        content: "Energy Monitor collects only the data necessary to provide energy monitoring services. This includes your energy meter readings, usage patterns, and account information."
                    )
                    
                    PrivacySection(
                        title: "Data Usage",
                        content: "Your data is used solely to provide personalized energy insights, generate consumption reports, and send relevant energy-saving recommendations."
                    )
                    
                    PrivacySection(
                        title: "Data Storage",
                        content: "All data is securely stored using Firebase services with industry-standard encryption. Your data is never shared with third parties without your explicit consent."
                    )
                    
                    PrivacySection(
                        title: "Your Rights",
                        content: "You have the right to access, modify, or delete your personal data at any time. You can export your data or request account deletion through the app settings."
                    )
                    
                    PrivacySection(
                        title: "Contact",
                        content: "If you have any questions about our privacy practices, please contact us at privacy@energymonitor.app"
                    )
                }
                
                Text("Last updated: January 2025")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.top)
            }
            .padding()
        }
        .navigationTitle("Privacy Policy")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct PrivacySection: View {
    let title: String
    let content: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
            
            Text(content)
                .font(.body)
                .foregroundColor(.secondary)
        }
    }
}
