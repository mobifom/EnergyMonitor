//
//  AppState.swift
//  EnergyMonitor
//
//  Created by Mohamed Hamdi on 27/07/2025.
//

// Application State Management
class AppState: ObservableObject {
    @Published var selectedTab: Int = 0
    @Published var isFirstLaunch: Bool = true
    
    init() {
        isFirstLaunch = !UserDefaults.standard.bool(forKey: "has_launched_before")
        if isFirstLaunch {
            UserDefaults.standard.set(true, forKey: "has_launched_before")
        }
    }
}
