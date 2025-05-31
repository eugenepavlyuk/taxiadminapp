//
//  InfoViewModel.swift
//  TaxiAdminApp
//
//  Created by Pavluk, Eugen on 29/05/2025.
//

import Foundation
import CoreLocation
import Resolver
import Combine

/*
 * View Model for Info Screen. Hides business logic for calculating total distance, speed etc.
 */
class InfoViewModel {
    
    private let NOTIFY_EVERY_METTERS: Double = 500
    
    // Dependencies
    @Injected private var locationManager: LocationManager
    @Injected private var notificationManager: NotificationsManager
    
    // Observable property
    @Published var currentLocation: CLLocation?
    private var cancellables = Set<AnyCancellable>()
    
    // Properties
    private var lastLocation: CLLocation?
    private var totalDistance: Double = 0
    private var previousTotalDistance: Double = 0
    
    init(locationManager: LocationManager, notificationManager: NotificationsManager) {
        self.locationManager = locationManager
        self.notificationManager = notificationManager
        
        locationManager.publisher()
            .sink { [weak self] location in
                self?.calculateTelemetry(location: location)
            }
            .store(in: &self.cancellables)
    }
    
    func calculateTelemetry(location: CLLocation?) {
        guard let location = location else { return }
        
        self.lastLocation = self.currentLocation
        self.currentLocation = location
        self.totalDistance += self.calculateDistance()
        
        if (self.totalDistance - self.previousTotalDistance > NOTIFY_EVERY_METTERS) {
            self.previousTotalDistance = self.totalDistance
            if (notificationManager.hasNotificationPermissions()) {
                notificationManager.scheduleNotificationWithText("Distance from starting point: \(Int(totalDistance)) m")
            }
        }
    }
    
    func coordinates() -> String {
        return "{\(currentLocation?.coordinate.latitude ?? 0), \(currentLocation?.coordinate.longitude ?? 0)}"
    }
    
    func speed() -> String {
        guard let speed = currentLocation?.speed else {
            return "0"
        }
        if speed >= 0 {
            return "\(Int(speed)) m/s"
        } else {
            return "0"
        }
    }
    
    func calculateDistance() -> Double {
        guard let currentLocation = currentLocation else { return 0.0 }

        if let lastLocation {
            let distance = currentLocation.distance(from: lastLocation)
            return distance
        }

        return 0.0
    }
    
    func distance() -> String {
        return "\(Int(totalDistance)) m"
    }
    
}
