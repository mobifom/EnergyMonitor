//
//  WeatherService.swift
//  EnergyMonitor
//
//  Created by Mohamed Hamdi on 29/07/2025.
//

// WeatherAPI Integration with Bilingual Support

import Foundation
import Combine
import CoreLocation

class WeatherService: ObservableObject {
    @Published var currentWeather: WeatherData?
    @Published var isLoading = false
    @Published var error: String?
    
    private let apiKey = "a6e0d7a9ab794b18bae111106250208" // Replace with actual API key
    private let baseURL = "https://api.weatherapi.com/v1"
    private var cancellables = Set<AnyCancellable>()
    
    func fetchWeather(for location: CLLocationCoordinate2D, language: String = "en") {
        isLoading = true
        error = nil
        
        let urlString = "\(baseURL)/forecast.json?key=\(apiKey)&q=\(location.latitude),\(location.longitude)&days=3&aqi=no&alerts=no&lang=\(language)"
        
        guard let url = URL(string: urlString) else {
            error = "Invalid URL"
            isLoading = false
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: WeatherData.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
            }, receiveValue: { [weak self] weather in
                self?.currentWeather = weather
            })
            .store(in: &cancellables)
    }
    
    func getACRecommendation(temperature: Double, humidity: Int, uv: Double) -> ACRecommendation {
        if temperature >= 35 {
            return ACRecommendation(
                mode: .cool,
                temperature: 24,
                reason: "High temperature detected",
                estimatedSavings: "15-20%"
            )
        } else if temperature >= 28 {
            return ACRecommendation(
                mode: .eco,
                temperature: 26,
                reason: "Moderate temperature - ECO mode recommended",
                estimatedSavings: "25-30%"
            )
        } else if temperature >= 22 {
            return ACRecommendation(
                mode: .fan,
                temperature: 0,
                reason: "Pleasant temperature - fan mode sufficient",
                estimatedSavings: "60-70%"
            )
        } else {
            return ACRecommendation(
                mode: .off,
                temperature: 0,
                reason: "Cool temperature - AC not needed",
                estimatedSavings: "100%"
            )
        }
    }
}
