//
//  Resolver+Extension.swift
//  TaxiAdminApp
//
//  Created by Pavluk, Eugen on 29/05/2025.
//

import Foundation
import Resolver

// Dependency Injection framework Resolver.
extension Resolver: @retroactive ResolverRegistering {
    
    public static func registerAllServices() {
        // we use scope Application, otherwise options will be created all the time.
        
        register { RealPermissionsManager() as PermissionsManager }
            .scope(.application)
        register { RealNetworkingManager() as NetworkingManager }
            .scope(.application)
        register { RealLocationManager() as LocationManager }
            .scope(.application)
        register { RealNotificationManager() as NotificationsManager }
            .scope(.application)
        
        register { ListViewModel() }
            .scope(.application)
        register { InfoViewModel(locationManager: resolve(), notificationManager: resolve()) }
            .scope(.application)
        register { MapViewModel(locationManager: resolve()) }
            .scope(.application)
    }
    
    // Instantiate some objections before hand, even before Map and Info screen appear
    public static func instantiateBeforehand() {
        _ = Resolver.resolve(MapViewModel.self)
        _ = Resolver.resolve(InfoViewModel.self)
    }
}
