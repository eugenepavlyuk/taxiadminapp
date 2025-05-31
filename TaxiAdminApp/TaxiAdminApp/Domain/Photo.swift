//
//  Photo.swift
//  TaxiAdminApp
//
//  Created by Pavluk, Eugen on 29/05/2025.
//

import Foundation

// Photo - decodable object so it can be converted from JSON to POJO
struct Photo: Decodable {
    
    let albumId: Int
    let id: Int
    let title: String
    let url: String
    let thumbnailUrl: String
    
}
