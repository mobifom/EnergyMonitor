//
//  LocalizationManager.swift
//  EnergyMonitor
//
//  Created by Mohamed Hamdi on 02/08/2025.
//
import Foundation
import CoreLocation
import Combine

class LocationManager: NSObject, ObservableObject {
    private let locationManager = CLLocationManager()
    @Published var location: CLLocationCoordinate2D?
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    
    private var locationCompletion: ((CLLocationCoordinate2D) -> Void)?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func requestLocation(completion: @escaping (CLLocationCoordinate2D) -> Void) {
        locationCompletion = completion
        
        switch authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.requestLocation()
        case .denied, .restricted:
            // Use default location (Riyadh, Saudi Arabia)
            completion(CLLocationCoordinate2D(latitude: 24.7136, longitude: 46.6753))
        @unknown default:
            break
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        
        DispatchQueue.main.async {
            self.location = location.coordinate
            self.locationCompletion?(location.coordinate)
            self.locationCompletion = nil
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error.localizedDescription)")
        // Use default location on error
        DispatchQueue.main.async {
            let defaultLocation = CLLocationCoordinate2D(latitude: 24.7136, longitude: 46.6753)
            self.locationCompletion?(defaultLocation)
            self.locationCompletion = nil
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        DispatchQueue.main.async {
            self.authorizationStatus = status
            
            switch status {
            case .authorizedWhenInUse, .authorizedAlways:
                self.locationManager.requestLocation()
            case .denied, .restricted:
                // Use default location
                if let completion = self.locationCompletion {
                    completion(CLLocationCoordinate2D(latitude: 24.7136, longitude: 46.6753))
                    self.locationCompletion = nil
                }
            default:
                break
            }
        }
    }
}

