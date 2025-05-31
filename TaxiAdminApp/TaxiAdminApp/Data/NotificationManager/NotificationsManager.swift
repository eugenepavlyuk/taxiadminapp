//
//  NotificationsManager.swift
//  TaxiAdminApp
//
//  Created by Pavluk, Eugen on 30/05/2025.
//

import Foundation
import UserNotifications

/*
 * Protocol for NotificationManager to hide implementation
 */
protocol NotificationsManager {
    
    func requestPermissions()
    func hasNotificationPermissions() -> Bool
    func scheduleNotificationWithText(_ text: String)
    
}

/*
 * Real Notification Manager
 */
class RealNotificationManager: NotificationsManager {
    
    private var permissionsGranted: Bool = false
    
    func requestPermissions() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] granted, error in
            self?.permissionsGranted = granted
        }
    }
    
    func hasNotificationPermissions() -> Bool {
        return permissionsGranted
    }
    
    func scheduleNotificationWithText(_ text: String) {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "TaxiAdmin"
        notificationContent.body = text
        notificationContent.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "taxi_sound.wav"))

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: notificationContent, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error {
                print("Error: \(error)")
            }
        }
    }
    
}
