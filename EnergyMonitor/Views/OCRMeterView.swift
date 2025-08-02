//
//  OCRMeterView.swift
//  EnergyMonitor
//
//  Created by Mohamed Hamdi on 02/08/2025.
//

import SwiftUI
import VisionKit
import Vision

struct OCRMeterView: View {
    @EnvironmentObject var localizationManager: LocalizationManager
    @StateObject private var ocrViewModel = OCRViewModel()
    @State private var showingImagePicker = false
    @State private var showingCamera = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                if let image = ocrViewModel.selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxHeight: 300)
                        .cornerRadius(12)
                } else {
                    Rectangle()
                        .fill(Color(.systemGray5))
                        .frame(height: 300)
                        .overlay(
                            VStack {
                                Image(systemName: "camera.fill")
                                    .font(.system(size: 50))
                                    .foregroundColor(.gray)
                                Text("Capture meter image")
                                    .foregroundColor(.gray)
                            }
                        )
                        .cornerRadius(12)
                }
                
                if ocrViewModel.isProcessing {
                    ProgressView(localizationManager.localizedString("processing"))
                        .frame(maxWidth: .infinity)
                }
                
                if let detectedReading = ocrViewModel.detectedReading {
                    VStack(spacing: 12) {
                        Text(localizationManager.localizedString("reading_detected"))
                            .font(.headline)
                        
                        Text("\(detectedReading, specifier: "%.1f") kWh")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.green)
                        
                        HStack(spacing: 16) {
                            Button("Retake") {
                                ocrViewModel.reset()
                                showingCamera = true
                            }
                            .buttonStyle(.bordered)
                            
                            Button("Save Reading") {
                                saveDetectedReading()
                            }
                            .buttonStyle(.borderedProminent)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                }
                
                if ocrViewModel.selectedImage == nil {
                    VStack(spacing: 12) {
                        Button(action: { showingCamera = true }) {
                            HStack {
                                Image(systemName: "camera.fill")
                                Text(localizationManager.localizedString("capture_image"))
                            }
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(12)
                        }
                        
                        Button("Choose from Library") {
                            showingImagePicker = true
                        }
                        .buttonStyle(.bordered)
                    }
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle(localizationManager.localizedString("scan_meter"))
            .sheet(isPresented: $showingCamera) {
                CameraView { image in
                    ocrViewModel.processImage(image)
                }
            }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker { image in
                    ocrViewModel.processImage(image)
                }
            }
        }
    }
    
    private func saveDetectedReading() {
        guard let reading = ocrViewModel.detectedReading else { return }
        
        let energyReading = EnergyReading(
            reading: reading,
            timestamp: Date(),
            meterType: .electricity,
            readingMethod: .ocr,
            notes: "OCR detected reading",
            imageURL: nil
        )
        
        // Save using energy view model
        // This would typically be injected or accessed through environment
    }
}
