//
//  AboutView.swift
//  EnergyMonitor
//
//  Created by Mohamed Hamdi on 02/08/2025.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // App Icon and Title
                VStack(spacing: 12) {
                    Image(systemName: "bolt.circle.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.green)
                    
                    Text("Energy Monitor")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Version 1.0.0")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                // Description
                Text("Energy Monitor helps you track your energy consumption, reduce costs, and make environmentally conscious decisions. Our app supports both Arabic and English languages and is designed specifically for the MENA region.")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                // Features
                VStack(alignment: .leading, spacing: 16) {
                    Text("Features")
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    FeatureRow(icon: "camera.fill", title: "OCR Meter Reading", description: "Scan your meter with camera")
                    FeatureRow(icon: "chart.line.uptrend.xyaxis", title: "Usage Analytics", description: "Track consumption patterns")
                    FeatureRow(icon: "lightbulb.fill", title: "Energy Tips", description: "Personalized saving recommendations")
                    FeatureRow(icon: "cloud.sun.fill", title: "Weather Integration", description: "AC recommendations based on weather")
                    FeatureRow(icon: "globe", title: "Bilingual Support", description: "Arabic and English languages")
                }
                .padding(.horizontal)
                
                // Developer Info
                VStack(spacing: 8) {
                    Text("Developed with ❤️ for the MENA region")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("© 2025 Energy Monitor. All rights reserved.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.top)
            }
            .padding()
        }
        .navigationTitle("About")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.green)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.headline)
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
    }
}
