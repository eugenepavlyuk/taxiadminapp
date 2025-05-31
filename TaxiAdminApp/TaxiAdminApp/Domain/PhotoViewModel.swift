//
//  PhotoViewModel.swift
//  TaxiAdminApp
//
//  Created by Pavluk, Eugen on 29/05/2025.
//

import Foundation

// PhotoViewModel. We cannot use Photo models in view controller in MVVM pattern, because photos need some preprocessing. Such business logic should be in ViewModel
struct PhotoViewModel {
    
    let id: String
    let thumbnailUrl: String
    let title: String
    
    init(photo: Photo) {
        id = "\(photo.id)"
        
        // get components from thumbnail url. Because via.placeholder.com does not work in Germany. Maybe works in Ukraine.
        var components = photo.thumbnailUrl.split(separator: "/")
        let color = components.last ?? "000000"  // get color
        components.removeLast()
        
        let dimension = components.last ?? "150" // get dimension
        
        // Use another service for generating photos: https://placehold.co
        thumbnailUrl = "https://placehold.co/\(dimension)/000000/\(color)/png"

        title = photo.title
    }
}
