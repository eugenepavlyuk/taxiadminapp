//
//  NetworkingManager.swift
//  TaxiAdminApp
//
//  Created by Pavluk, Eugen on 29/05/2025.
//

import Foundation

/*
 * Protocol for Networking Manager to hide implementation
 */
protocol NetworkingManager {
    
    func fetch<T: Decodable>(_ urlRequest: URLRequest) async throws -> T
}

/*
 * Real implementation of Networking Manager
 */
class RealNetworkingManager: NetworkingManager {
    
    func fetch<T: Decodable>(_ urlRequest: URLRequest) async throws -> T {
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        return try JSONDecoder().decode(T.self, from: data)
    }
}
