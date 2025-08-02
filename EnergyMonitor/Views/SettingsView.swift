//
//  SettingsView.swift
//  EnergyMonitor
//
//  Created by Mohamed Hamdi on 02/08/2025.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var localizationManager: LocalizationManager
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @State private var selectedRegion = "Saudi Arabia"
    @State private var selectedCurrency = "SAR"
    @State private var notificationsEnabled = true
    @State private var highUsageAlerts = true
    @State private var showingLanguageSheet = false
    @State private var showingRegionSheet = false
    
    private let regions = ["Saudi Arabia", "UAE", "Kuwait", "Egypt", "Jordan", "Qatar", "Bahrain", "Oman"]
    private let currencies = ["SAR", "AED", "KWD", "EGP", "JOD", "QAR", "BHD", "OMR"]
    
    var body: some View {
        NavigationView {
            Form {
                // Profile Section
                Section {
                    HStack {
                        Image(systemName: "person.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(.blue)
                        
                        VStack(alignment: .leading) {
                            Text(authViewModel.currentUser?.email ?? "User")
                                .font(.headline)
                            Text("Energy Monitor User")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                    }
                    .padding(.vertical, 8)
                }
                
                // App Settings
                Section(header: Text("App Settings")) {
                    HStack {
                        Image(systemName: "globe")
                        Text(localizationManager.localizedString("language"))
                        Spacer()
                        Text(localizationManager.currentLanguage.displayName)
                            .foregroundColor(.secondary)
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        showingLanguageSheet = true
                    }
                    
                    HStack {
                        Image(systemName: "location")
                        Text(localizationManager.localizedString("region"))
                        Spacer()
                        Text(selectedRegion)
                            .foregroundColor(.secondary)
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        showingRegionSheet = true
                    }
                    
                    Picker(localizationManager.localizedString("currency"), selection: $selectedCurrency) {
                        ForEach(currencies, id: \.self) { currency in
                            Text(currency).tag(currency)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                
                // Notifications
                Section(header: Text(localizationManager.localizedString("notifications"))) {
                    Toggle("Enable Notifications", isOn: $notificationsEnabled)
                    Toggle("High Usage Alerts", isOn: $highUsageAlerts)
                        .disabled(!notificationsEnabled)
                }
                
                // Data & Privacy
                Section(header: Text("Data & Privacy")) {
                    NavigationLink(destination: DataExportView()) {
                        Label("Export Data", systemImage: "square.and.arrow.up")
                    }
                    
                    NavigationLink(destination: PrivacyView()) {
                        Label("Privacy Policy", systemImage: "hand.raised")
                    }
                    
                    Button(action: clearAllData) {
                        Label("Clear All Data", systemImage: "trash")
                            .foregroundColor(.red)
                    }
                }
                
                // About
                Section(header: Text(localizationManager.localizedString("about"))) {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                    
                    NavigationLink(destination: AboutView()) {
                        Label("About Energy Monitor", systemImage: "info.circle")
                    }
                    
                    Link("Rate App", destination: URL(string: "https://apps.apple.com")!)
                }
                
                // Sign Out
                Section {
                    Button(action: authViewModel.signOut) {
                        HStack {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                            Text("Sign Out")
                        }
                        .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle(localizationManager.localizedString("settings"))
            .sheet(isPresented: $showingLanguageSheet) {
                LanguageSelectionView()
            }
            .sheet(isPresented: $showingRegionSheet) {
                RegionSelectionView(selectedRegion: $selectedRegion)
            }
            .onAppear {
                loadSettings()
            }
            .onChange(of: selectedRegion) { newRegion in
                UserDefaults.standard.set(newRegion, forKey: "selectedRegion")
            }
            .onChange(of: selectedCurrency) { newCurrency in
                UserDefaults.standard.set(newCurrency, forKey: "selectedCurrency")
            }
        }
    }
    
    private func loadSettings() {
        selectedRegion = UserDefaults.standard.string(forKey: "selectedRegion") ?? "Saudi Arabia"
        selectedCurrency = UserDefaults.standard.string(forKey: "selectedCurrency") ?? "SAR"
        notificationsEnabled = UserDefaults.standard.bool(forKey: "notificationsEnabled")
        highUsageAlerts = UserDefaults.standard.bool(forKey: "highUsageAlerts")
    }
    
    private func clearAllData() {
        // Implementation to clear all user data
        let alert = UIAlertController(
            title: "Clear All Data",
            message: "This will permanently delete all your energy readings and settings. This action cannot be undone.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { _ in
            // Clear UserDefaults
            let defaults = UserDefaults.standard
            defaults.removeObject(forKey: "selectedRegion")
            defaults.removeObject(forKey: "selectedCurrency")
            defaults.removeObject(forKey: "notificationsEnabled")
            defaults.removeObject(forKey: "highUsageAlerts")
            
            // Clear Firestore data would go here
        })
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController?.present(alert, animated: true)
        }
    }
}

struct LanguageSelectionView: View {
    @EnvironmentObject var localizationManager: LocalizationManager
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            List {
                ForEach(LocalizationManager.Language.allCases, id: \.self) { language in
                    HStack {
                        Text(language.displayName)
                        Spacer()
                        if localizationManager.currentLanguage == language {
                            Image(systemName: "checkmark")
                                .foregroundColor(.green)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        localizationManager.setLanguage(language)
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .navigationTitle("Select Language")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

struct RegionSelectionView: View {
    @Binding var selectedRegion: String
    @Environment(\.presentationMode) var presentationMode
    
    private let regions = [
        "Saudi Arabia", "UAE", "Kuwait", "Egypt",
        "Jordan", "Qatar", "Bahrain", "Oman"
    ]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(regions, id: \.self) { region in
                    HStack {
                        Text(region)
                        Spacer()
                        if selectedRegion == region {
                            Image(systemName: "checkmark")
                                .foregroundColor(.green)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectedRegion = region
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .navigationTitle("Select Region")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}
