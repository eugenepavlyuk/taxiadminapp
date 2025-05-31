//
//  InfoViewController.swift
//  TaxiAdminApp
//
//  Created by Pavluk, Eugen on 28/05/2025.
//

import Foundation
import UIKit
import Resolver
import Combine

/*
 * Info screen, shows Speed, coordinates and distance
 */
class InfoViewController: ContentViewController {
    
    // UI Elements
    @IBOutlet private weak var coordinatesLabel: UILabel?
    @IBOutlet private weak var speedLabel: UILabel?
    @IBOutlet private weak var distanceLabel: UILabel?
    
    // Dependencies
    @LazyInjected private var infoViewModel: InfoViewModel
    
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // start listening to location updates
        bindLocation()
    }
    
    private func bindLocation() {
        infoViewModel.$currentLocation
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.updateTelemetry()
            }
            .store(in: &cancellables)
    }
    
    private func updateTelemetry() {
        coordinatesLabel?.text = infoViewModel.coordinates()
        speedLabel?.text = infoViewModel.speed()
        distanceLabel?.text = infoViewModel.distance()
    }
}
