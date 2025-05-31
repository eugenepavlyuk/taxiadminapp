//
//  PermissionsManager.swift
//  TaxiAdminApp
//
//  Created by Pavluk, Eugen on 29/05/2025.
//

import Foundation
import Resolver

/*
 * Protocol for PermissionsManager to hide implementation
 */
protocol PermissionsManager {
    
    func requestPermissions()
    func hasLocationPermission() -> Bool
    
}

/*
 * Real implementation of PermissionsManager
 */
class RealPermissionsManager: PermissionsManager {
    
    // Dependencies
    @LazyInjected private var locationManager: LocationManager
    @LazyInjected private var notificationManager: NotificationsManager
    
    func requestPermissions() {
        locationManager.requestPermissions()
        notificationManager.requestPermissions()
    }
    
    func hasLocationPermission() -> Bool {
        return locationManager.hasLocationPermissions()
    }
    
    func hasNotificationPermission() -> Bool {
        return notificationManager.hasNotificationPermissions()
    }
    
}
