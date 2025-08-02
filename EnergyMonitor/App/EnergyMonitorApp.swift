//
//  Mowaffir_Al_TaqaApp.swift
//  Mowaffir Al-Taqa
//
//  Created by Mohamed Hamdi on 27/07/2025.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore

@main
struct EnergyMonitorApp: App {
    @StateObject private var authViewModel = AuthenticationViewModel()
    @StateObject private var localizationManager = LocalizationManager()
    @StateObject private var weatherService = WeatherService()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authViewModel)
                .environmentObject(localizationManager)
                .environmentObject(weatherService)
                .environment(\.layoutDirection, localizationManager.isArabic ? .rightToLeft : .leftToRight)
        }
    }
}
