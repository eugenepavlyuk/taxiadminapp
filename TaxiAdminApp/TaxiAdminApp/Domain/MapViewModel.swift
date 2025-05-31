//
//  MapViewModel.swift
//  TaxiAdminApp
//
//  Created by Pavluk, Eugen on 29/05/2025.
//

import Foundation
import Resolver
import MapKit
import Combine

// View Model for Map screen
class MapViewModel {
    
    private let DEFAULT_REGION_SIZE = 2000.0
    private let DEFAULT_NUMBER_OF_POINTS_TO_TRACK = 100
    
    // Dependencies
    @Injected private var locationManager: LocationManager
    private var cancellables = Set<AnyCancellable>()
    
    // Observable property
    @Published var currentLocation: CLLocationCoordinate2D?
    @Published var lastCoordinates: [CLLocationCoordinate2D] = []
    
    // Properties
    var ignoreMapRegionUpdates: Bool = false
    
    init(locationManager: LocationManager) {
        self.locationManager = locationManager
        
        locationManager.publisher()
            .sink { [weak self] location in
                self?.handleLocationUpdate(location)
            }
            .store(in: &self.cancellables)
    }
    
    func regionWithLocation(_ location: CLLocationCoordinate2D?) -> MKCoordinateRegion? {
        guard let location = location else { return nil }
        return MKCoordinateRegion(center: location, latitudinalMeters: DEFAULT_REGION_SIZE, longitudinalMeters: DEFAULT_REGION_SIZE)
    }
    
    func handleLocationUpdate(_ location: CLLocation) {
        currentLocation = location.coordinate
        lastCoordinates.append(location.coordinate)
        if lastCoordinates.count > DEFAULT_NUMBER_OF_POINTS_TO_TRACK {
            lastCoordinates.removeFirst()
        }
    }
    
    func startLocationMonitoring() {
        locationManager.startMonitoringLocation()
    }
    
    func mapItem(location: CLLocationCoordinate2D, text: String) -> MKMapItem {
        let placemark = MKPlacemark(coordinate: location)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = text
        return mapItem
    }
}
