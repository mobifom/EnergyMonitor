//
//  Untitled.swift
//  EnergyMonitor
//
//  Created by Mohamed Hamdi on 02/08/2025.
//

class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        handleNotificationResponse(response)
        completionHandler()
    }
    
    private func handleNotificationResponse(_ response: UNNotificationResponse) {
        switch response.actionIdentifier {
        case "READ_NOW":
            // Navigate to meter reading screen
            NotificationCenter.default.post(name: .navigateToMeterReading, object: nil)
        case "REMIND_LATER":
            // Schedule reminder for later
            break
        default:
            break
        }
    }
}

extension Notification.Name {
    static let navigateToMeterReading = Notification.Name("navigateToMeterReading")
}
