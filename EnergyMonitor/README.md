//
//  README.md
//  EnergyMonitor
//
//  Created by Mohamed Hamdi on 02/08/2025.
//


/*
# Energy Monitor App

A comprehensive bilingual (Arabic/English) iOS app for monitoring energy consumption, designed specifically for the MENA region.

## Features

### 🏠 Home Dashboard
- Real-time weather integration with WeatherAPI
- Intelligent AC recommendations based on weather conditions
- Daily energy-saving tips
- Quick consumption statistics
- RTL support for Arabic interface

### 📊 Usage Tracking
- Manual meter reading entry
- Consumption analytics with interactive charts
- Monthly bill estimation with regional tariff rates
- Data export functionality (CSV/Excel)
- Historical consumption trends

### 📷 OCR Meter Reading
- Camera-based meter scanning using Apple VisionKit
- Arabic and English numeral recognition
- Automatic reading detection and validation
- Image processing with error handling

### 💡 Energy Tips
- Categorized tips (cooling, lighting, appliances, general)
- Bilingual content with cultural adaptation
- Difficulty levels and estimated savings
- Search and filter functionality

### ⚙️ Settings
- Complete Arabic/English localization
- Regional customization (SA, UAE, Kuwait, Egypt, Jordan, etc.)
- Currency support for local markets
- Notification preferences
- Privacy controls and data export

## Technical Implementation

### Architecture
- **SwiftUI** with MVVM pattern
- **Firebase** backend (Auth, Firestore, Storage, Analytics)
- **Combine** for reactive programming
- **WeatherAPI** for weather data
- **Apple VisionKit** for OCR functionality

### Key Components

#### Models
- `EnergyReading` - Core data model for meter readings
- `WeatherData` - Weather API response structure
- `EnergyTip` - Bilingual energy-saving recommendations
- `ACRecommendation` - Smart AC mode suggestions

#### Services
- `WeatherService` - WeatherAPI integration with Arabic support
- `LocalizationManager` - Complete RTL and bilingual support
- `OCRViewModel` - Vision-based meter reading processing
- `EnergyReadingViewModel` - Firestore data management

#### Views
- `HomeDashboardView` - Main dashboard with weather and stats
- `UsageTrackingView` - Analytics and consumption charts
- `OCRMeterView` - Camera integration for meter scanning
- `EnergyTipsView` - Categorized tips with search
- `SettingsView` - Comprehensive app configuration

### Localization Support
- Complete Arabic/English translation system
- RTL layout adaptation
- Arabic numeral recognition in OCR
- Cultural adaptation for MENA region

### Regional Features
- **Tariff Calculation**: Built-in electricity rates for major MENA countries
- **Currency Support**: Local currency formatting (SAR, AED, KWD, EGP, JOD, etc.)
- **Cultural Adaptation**: Energy tips tailored to regional climate and practices
- **Weather Integration**: Arabic language support for weather descriptions

## Setup Instructions

### Prerequisites
- Xcode 15.0+
- iOS 16.0+
- Firebase project setup
- WeatherAPI key

### Installation
1. Clone the repository
2. Add `GoogleService-Info.plist` from Firebase Console
3. Replace `YOUR_WEATHERAPI_KEY` in `WeatherService.swift`
4. Install dependencies via Swift Package Manager:
   - Firebase iOS SDK
   - Swift Charts

### Firebase Configuration
```swift
// Required Firebase services
- Authentication
- Firestore Database
- Storage
- Analytics
```

### API Keys Required
- **WeatherAPI**: Free tier supports 1M calls/month
- **Firebase**: Free Spark plan included

## File Structure

```
EnergyMonitor/
├── App/
│   ├── EnergyMonitorApp.swift          # Main app entry point
│   └── ContentView.swift               # Root navigation
├── Views/
│   ├── MainTabView.swift              # Tab navigation
│   ├── HomeDashboardView.swift        # Dashboard with weather
│   ├── UsageTrackingView.swift        # Analytics and charts
│   ├── OCRMeterView.swift             # Camera scanning
│   ├── EnergyTipsView.swift           # Tips and recommendations
│   ├── SettingsView.swift             # App configuration
│   ├── LoginView.swift                # Authentication
│   └── Supporting Views/              # Additional UI components
├── ViewModels/
│   ├── AuthenticationViewModel.swift   # User authentication
│   ├── EnergyReadingViewModel.swift   # Data management
│   └── OCRViewModel.swift             # Image processing
├── Models/
│   ├── EnergyReading.swift            # Core data model
│   ├── WeatherData.swift             # Weather API models
│   ├── EnergyTip.swift               # Tips structure
│   └── ACRecommendation.swift        # AC suggestions
├── Services/
│   ├── WeatherService.swift          # WeatherAPI integration
│   ├── LocalizationManager.swift     # Bilingual support
│   ├── LocationManager.swift         # GPS functionality
│   └── NotificationManager.swift     # Push notifications
├── Utils/
│   ├── TariffCalculator.swift        # Regional billing
│   ├── CSVExporter.swift             # Data export
│   └── EnergyInsights.swift          # Analytics engine
├── Extensions/
│   ├── Date+Extensions.swift         # Date utilities
│   ├── Double+Extensions.swift       # Number formatting
│   └── Color+Extensions.swift        # UI colors
├── Resources/
│   ├── en.lproj/Localizable.strings  # English translations
│   ├── ar.lproj/Localizable.strings  # Arabic translations
│   └── Info.plist                    # App configuration
└── Configuration/
    └── GoogleService-Info.plist       # Firebase config
```

## Development Roadmap

### Phase 1: Core Infrastructure (Weeks 1-2)
- [x] Project setup and architecture
- [x] Firebase integration
- [x] Bilingual localization system
- [x] Basic UI components

### Phase 2: Dashboard & Weather (Weeks 3-4)
- [x] Weather API integration
- [x] Home dashboard implementation
- [x] AC recommendation engine
- [x] Real-time data display

### Phase 3: Usage Tracking (Weeks 5-6)
- [x] Manual reading entry
- [x] Data visualization with charts
- [x] Consumption analytics
- [x] Bill estimation system

### Phase 4: OCR Implementation (Weeks 7-8)
- [x] Camera integration
- [x] Vision-based text recognition
- [x] Arabic numeral support
- [x] Reading validation

### Phase 5: Smart Features (Weeks 9-10)
- [x] Energy tips system
- [x] Usage pattern analysis
- [x] Notification system
- [x] Data export functionality

### Phase 6: Polish & Testing (Weeks 11-12)
- [x] UI/UX refinements
- [x] Performance optimization
- [x] Comprehensive testing
- [x] App Store preparation

## Regional Market Considerations

### Saudi Arabia
- Tiered electricity tariffs (0.18 - 0.30 SAR/kWh)
- High AC usage due to extreme climate
- Government energy efficiency initiatives (Saudi Vision 2030)

### UAE
- Multi-tier pricing structure
- Focus on smart city initiatives
- High energy costs incentivize monitoring

### Kuwait & Other GCC
- Subsidized energy prices
- Growing awareness of consumption
- Smart meter rollout programs

### Egypt & Jordan
- Complex tiered pricing systems
- Energy subsidy reforms
- Rising utility costs

## Privacy & Compliance

- **GDPR Compliant**: User data control and export
- **Local Data Storage**: Firebase with regional hosting
- **Minimal Data Collection**: Only essential energy metrics
- **User Consent**: Clear privacy policy and opt-in features

## Contributing

This codebase is production-ready with proper error handling, localization support, and scalable architecture. The app is designed for 12-week development cycle with clear milestones and deliverables.

## License

Proprietary - Energy Monitor App
© 2025 All rights reserved.
*/
