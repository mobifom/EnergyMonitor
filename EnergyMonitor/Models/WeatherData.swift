//
//  WeatherData.swift
//  EnergyMonitor
//
//  Created by Mohamed Hamdi on 02/08/2025.
//

import Foundation

struct WeatherData: Codable {
    let location: Location
    let current: Current
    let forecast: Forecast?
    
    struct Location: Codable {
        let name: String
        let region: String
        let country: String
        let lat: Double
        let lon: Double
        let localtime: String
    }
    
    struct Current: Codable {
        let tempC: Double
        let tempF: Double
        let condition: Condition
        let windKph: Double
        let windDir: String
        let humidity: Int
        let feelslikeC: Double
        let feelslikeF: Double
        let uv: Double
        
        enum CodingKeys: String, CodingKey {
            case tempC = "temp_c"
            case tempF = "temp_f"
            case condition
            case windKph = "wind_kph"
            case windDir = "wind_dir"
            case humidity
            case feelslikeC = "feelslike_c"
            case feelslikeF = "feelslike_f"
            case uv
        }
    }
    
    struct Condition: Codable {
        let text: String
        let icon: String
        let code: Int
    }
    
    struct Forecast: Codable {
        let forecastday: [ForecastDay]
    }
    
    struct ForecastDay: Codable {
        let date: String
        let day: Day
        
        struct Day: Codable {
            let maxtempC: Double
            let mintempC: Double
            let condition: Condition
            
            enum CodingKeys: String, CodingKey {
                case maxtempC = "maxtemp_c"
                case mintempC = "mintemp_c"
                case condition
            }
        }
    }
}
