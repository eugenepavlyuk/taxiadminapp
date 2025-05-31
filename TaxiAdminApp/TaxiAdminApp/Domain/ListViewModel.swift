//
//  ListViewModel.swift
//  TaxiAdminApp
//
//  Created by Pavluk, Eugen on 29/05/2025.
//

import Foundation
import Resolver

/*
 * View Model for List Screen
 */
class ListViewModel {
    
    private let PHOTOS_URL = "https://jsonplaceholder.typicode.com/photos"
    
    // Dependencies
    @LazyInjected private var networkingManager: NetworkingManager
    
    // Properties
    private var photosViewModels: [PhotoViewModel] = []
    
    func fetchPhotos() async {
        do {
            let photos: [Photo] = try await networkingManager.fetch(URLRequest(url: URL(string: PHOTOS_URL)!))
            photosViewModels = photos.map(PhotoViewModel.init) // convert Photos to PhotoViewModel.
        } catch {
            photosViewModels = []
            print("Error happened during fetching photos: \(error)")
        }
    }
    
    func numberOfPhotos() -> Int {
        return photosViewModels.count
    }
    
    func photoViewModel(at index: Int) -> PhotoViewModel {
        return photosViewModels[index]
    }
}
