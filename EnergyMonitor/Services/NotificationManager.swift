//
//  NotificationManager.swift
//  EnergyMonitor
//
//  Created by Mohamed Hamdi on 02/08/2025.
//

import Foundation
import UserNotifications
import UIKit

class NotificationManager: ObservableObject {
    static let shared = NotificationManager()
    
    private init() {}
    
    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Notification permission granted")
            } else if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            }
        }
    }
    
    func scheduleDailyTipNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Daily Energy Tip"
        content.body = "Check out today's energy-saving tip!"
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.hour = 9 // 9 AM
        dateComponents.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "dailyTip", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    func scheduleHighUsageAlert(consumption: Double, threshold: Double) {
        guard consumption > threshold else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "High Energy Usage Alert"
        content.body = "Your energy consumption is \(Int(consumption)) kWh, which is above your threshold of \(Int(threshold)) kWh."
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "highUsage", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
}
