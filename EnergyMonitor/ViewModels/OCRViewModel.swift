//
//  OCRViewModel.swift
//  EnergyMonitor
//
//  Created by Mohamed Hamdi on 02/08/2025.
//

import Foundation
import UIKit
import Vision
import Combine

class OCRViewModel: ObservableObject {
    @Published var selectedImage: UIImage?
    @Published var detectedReading: Double?
    @Published var isProcessing = false
    @Published var errorMessage: String?
    
    func processImage(_ image: UIImage) {
        selectedImage = image
        isProcessing = true
        errorMessage = nil
        detectedReading = nil
        
        guard let cgImage = image.cgImage else {
            errorMessage = "Failed to process image"
            isProcessing = false
            return
        }
        
        let request = VNRecognizeTextRequest { [weak self] request, error in
            DispatchQueue.main.async {
                self?.handleTextRecognition(request: request, error: error)
            }
        }
        
        // Configure for better number recognition
        request.recognitionLevel = .accurate
        request.recognitionLanguages = ["en-US", "ar-SA"]
        request.usesLanguageCorrection = false
        
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try handler.perform([request])
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                    self.isProcessing = false
                }
            }
        }
    }
    
    private func handleTextRecognition(request: VNRequest, error: Error?) {
        isProcessing = false
        
        if let error = error {
            errorMessage = error.localizedDescription
            return
        }
        
        guard let observations = request.results as? [VNRecognizedTextObservation] else {
            errorMessage = "No text detected"
            return
        }
        
        let recognizedStrings = observations.compactMap { observation in
            observation.topCandidates(1).first?.string
        }
        
        // Extract numeric values that could be meter readings
        let numbers = extractNumbers(from: recognizedStrings)
        
        if let reading = findMostLikelyReading(from: numbers) {
            detectedReading = reading
        } else {
            errorMessage = "No meter reading found"
        }
    }
    
    private func extractNumbers(from strings: [String]) -> [Double] {
        var numbers: [Double] = []
        
        for string in strings {
            // Use regex to find numbers (including Arabic numerals)
            let pattern = #"[\d٠-٩]+\.?[\d٠-٩]*"#
            let regex = try? NSRegularExpression(pattern: pattern)
            let range = NSRange(location: 0, length: string.utf16.count)
            
            regex?.enumerateMatches(in: string, range: range) { match, _, _ in
                guard let matchRange = match?.range,
                      let range = Range(matchRange, in: string) else { return }
                
                let numberString = String(string[range])
                let convertedString = convertArabicNumerals(numberString)
                
                if let number = Double(convertedString) {
                    numbers.append(number)
                }
            }
        }
        
        return numbers
    }
    
    private func convertArabicNumerals(_ string: String) -> String {
        let arabicNumerals = ["٠": "0", "١": "1", "٢": "2", "٣": "3", "٤": "4",
                             "٥": "5", "٦": "6", "٧": "7", "٨": "8", "٩": "9"]
        
        var result = string
        for (arabic, english) in arabicNumerals {
            result = result.replacingOccurrences(of: arabic, with: english)
        }
        return result
    }
    
    private func findMostLikelyReading(from numbers: [Double]) -> Double? {
        // Filter numbers that could be reasonable meter readings
        let validReadings = numbers.filter { number in
            number >= 0 && number <= 999999 && number >= 100 // Reasonable meter reading range
        }
        
        // Return the largest number as it's most likely the cumulative reading
        return validReadings.max()
    }
    
    func reset() {
        selectedImage = nil
        detectedReading = nil
        errorMessage = nil
        isProcessing = false
    }
}
