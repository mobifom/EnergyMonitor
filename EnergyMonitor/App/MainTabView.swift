//
//  MainTabView.swift
//  EnergyMonitor
//
//  Created by Mohamed Hamdi on 02/08/2025.
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var localizationManager: LocalizationManager
    
    var body: some View {
        TabView {
            HomeDashboardView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text(localizationManager.localizedString("home"))
                }
            
            UsageTrackingView()
                .tabItem {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                    Text(localizationManager.localizedString("usage"))
                }
            
            OCRMeterView()
                .tabItem {
                    Image(systemName: "camera.fill")
                    Text(localizationManager.localizedString("scan"))
                }
            
            EnergyTipsView()
                .tabItem {
                    Image(systemName: "lightbulb.fill")
                    Text(localizationManager.localizedString("tips"))
                }
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text(localizationManager.localizedString("settings"))
                }
        }
        .accentColor(.green)
    }
}
