//
//  LocationManager.swift
//  TaxiAdminApp
//
//  Created by Pavluk, Eugen on 29/05/2025.
//

import Foundation
import CoreLocation
import Combine

/*
 * Protocol for LocationManager to hide implementation
 */
protocol LocationManager {
    
    func publisher() -> AnyPublisher<CLLocation, Never>
    
    func requestPermissions()
    func hasLocationPermissions() -> Bool
    func userCurrentLocation() -> CLLocationCoordinate2D?
    func startMonitoringLocation()
    
}

/*
 * Real implementation of LocationManager
 */
class RealLocationManager: NSObject, LocationManager {
    
    private let locationManager = CLLocationManager()
    private let subject = PassthroughSubject<CLLocation, Never>()
    
    func publisher() -> AnyPublisher<CLLocation, Never> {
        return subject.eraseToAnyPublisher()
    }
    
    func requestPermissions() {
        locationManager.requestAlwaysAuthorization()
    }
    
    func userCurrentLocation() -> CLLocationCoordinate2D? {
        return locationManager.location?.coordinate
    }
    
    func hasLocationPermissions() -> Bool {
        return locationManager.authorizationStatus == .authorizedAlways
    }
    
    func startMonitoringLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.startUpdatingLocation()
    }
    
}

extension RealLocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        subject.send(location)
    }
    
}
