//
//  HomeDashboardView.swift
//  EnergyMonitor
//
//  Created by Mohamed Hamdi on 02/08/2025.
//

import SwiftUI
import CoreLocation

struct HomeDashboardView: View {
    @EnvironmentObject var localizationManager: LocalizationManager
    @EnvironmentObject var weatherService: WeatherService
    @StateObject private var locationManager = LocationManager()
    @StateObject private var energyViewModel = EnergyReadingViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Weather Card
                    WeatherCardView()
                    
                    // AC Recommendation
                    ACRecommendationCardView()
                    
                    // Daily Tip
                    DailyTipCardView()
                    
                    // Quick Stats
                    QuickStatsCardView()
                }
                .padding()
            }
            .navigationTitle(localizationManager.localizedString("home"))
            .onAppear {
                energyViewModel.fetchReadings()
                requestLocationAndFetchWeather()
            }
        }
    }
    
    private func requestLocationAndFetchWeather() {
        locationManager.requestLocation { location in
            let language = localizationManager.isArabic ? "ar" : "en"
            weatherService.fetchWeather(for: location, language: language)
        }
    }
}

struct WeatherCardView: View {
    @EnvironmentObject var weatherService: WeatherService
    @EnvironmentObject var localizationManager: LocalizationManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "cloud.sun.fill")
                    .foregroundColor(.blue)
                Text(localizationManager.localizedString("current_weather"))
                    .font(.headline)
                Spacer()
            }
            
            if let weather = weatherService.currentWeather {
                HStack {
                    VStack(alignment: .leading) {
                        Text("\(Int(weather.current.tempC))°C")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Text(weather.current.condition.text)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        Label("\(weather.current.humidity)%", systemImage: "drop.fill")
                        Label("\(Int(weather.current.windKph)) km/h", systemImage: "wind")
                    }
                    .font(.caption)
                    .foregroundColor(.secondary)
                }
            } else if weatherService.isLoading {
                HStack {
                    ProgressView()
                    Text(localizationManager.localizedString("loading"))
                }
            } else {
                Text("Weather data unavailable")
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct ACRecommendationCardView: View {
    @EnvironmentObject var weatherService: WeatherService
    @EnvironmentObject var localizationManager: LocalizationManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "air.conditioner.horizontal")
                    .foregroundColor(.green)
                Text(localizationManager.localizedString("ac_recommendation"))
                    .font(.headline)
                Spacer()
            }
            
            if let weather = weatherService.currentWeather {
                let recommendation = weatherService.getACRecommendation(
                    temperature: weather.current.tempC,
                    humidity: weather.current.humidity,
                    uv: weather.current.uv
                )
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Mode: \(recommendation.mode.rawValue.capitalized)")
                            .fontWeight(.semibold)
                        Spacer()
                        if recommendation.temperature > 0 {
                            Text("\(recommendation.temperature)°C")
                                .fontWeight(.semibold)
                        }
                    }
                    
                    Text(recommendation.reason)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    HStack {
                        Text("Estimated Savings:")
                            .font(.caption)
                        Text(recommendation.estimatedSavings)
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.green)
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct DailyTipCardView: View {
    @EnvironmentObject var localizationManager: LocalizationManager
    
    private let dailyTips = [
        EnergyTip(
            titleAR: "اضبط المكيف على 24 درجة",
            titleEN: "Set AC to 24°C",
            descriptionAR: "كل درجة أقل تزيد استهلاك الكهرباء بنسبة 6-8%",
            descriptionEN: "Each degree lower increases electricity consumption by 6-8%",
            category: .cooling,
            estimatedSavings: "15-20%",
            difficulty: .easy,
            icon: "thermometer"
        ),
        EnergyTip(
            titleAR: "استخدم المراوح مع المكيف",
            titleEN: "Use fans with AC",
            descriptionAR: "المراوح تساعد على توزيع الهواء البارد بشكل أفضل",
            descriptionEN: "Fans help distribute cool air more effectively",
            category: .cooling,
            estimatedSavings: "10-15%",
            difficulty: .easy,
            icon: "fan"
        )
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "lightbulb.fill")
                    .foregroundColor(.yellow)
                Text(localizationManager.localizedString("daily_tip"))
                    .font(.headline)
                Spacer()
            }
            
            let randomTip = dailyTips.randomElement() ?? dailyTips[0]
            let title = localizationManager.isArabic ? randomTip.titleAR : randomTip.titleEN
            let description = localizationManager.isArabic ? randomTip.descriptionAR : randomTip.descriptionEN
            
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .fontWeight(.semibold)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                HStack {
                    Label("Savings: \(randomTip.estimatedSavings)", systemImage: "leaf.fill")
                        .font(.caption)
                        .foregroundColor(.green)
                    Spacer()
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct QuickStatsCardView: View {
    @EnvironmentObject var localizationManager: LocalizationManager
    @StateObject private var energyViewModel = EnergyReadingViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "chart.bar.fill")
                    .foregroundColor(.purple)
                Text(localizationManager.localizedString("quick_stats"))
                    .font(.headline)
                Spacer()
            }
            
            HStack(spacing: 20) {
                VStack {
                    Text("\(Int(energyViewModel.calculateMonthlyConsumption()))")
                        .font(.title2)
                        .fontWeight(.bold)
                    Text("kWh")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(localizationManager.localizedString("this_month"))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack {
                    if let lastReading = energyViewModel.readings.first {
                        Text("\(Int(lastReading.reading))")
                            .font(.title2)
                            .fontWeight(.bold)
                        Text("kWh")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(localizationManager.localizedString("last_reading"))
                            .font(.caption)
                            .foregroundColor(.secondary)
                    } else {
                        Text("--")
                            .font(.title2)
                            .fontWeight(.bold)
                        Text("No data")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .onAppear {
            energyViewModel.fetchReadings()
        }
    }
}
