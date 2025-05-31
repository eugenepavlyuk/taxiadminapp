//
//  MapViewController.swift
//  TaxiAdminApp
//
//  Created by Pavluk, Eugen on 27/05/2025.
//

import Foundation
import UIKit
import SideMenu
import Resolver
import MapKit
import Combine

/*
 * Map Screen. Contains:
 * - map;
 * - button to center map according to user location;
 * - go to Apple Maps button
 */
class MapViewController: ContentViewController {
    
    // UI elements
    @IBOutlet private weak var mapView: MKMapView?
    @IBOutlet private weak var centerButton: UIButton?
    @IBOutlet private weak var goToAppleMapsButton: UIButton?
    
    // Dependencies
    @Injected private var mapViewModel: MapViewModel
    @Injected private var permissionsManager: PermissionsManager
    
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // some extra setup for left side menu
        setupSideMenu()
        
        bindLocation()   // start listening to location updates
        bindPath()       // start listerning to last 100 points
        
        // set up gesture recognizer for opening Left Side menu
        setupGesture()
    }
    
    // Subscribe to location updates with the help of Combine
    private func bindLocation() {
        mapViewModel.$currentLocation
            .receive(on: DispatchQueue.main)
            .sink { [weak self] location in
                self?.updateMapWithUserLocation(location)
            }
            .store(in: &cancellables)
    }
    
    // Subscribe to last 100 points
    private func bindPath() {
        mapViewModel.$lastCoordinates
            .receive(on: DispatchQueue.main)
            .sink { [weak self] coordinates in
                self?.updateMapWithUserPathCoordinates(coordinates)
            }
            .store(in: &cancellables)
    }
    
    // set up gesture recognizer for left side menu opening
    private func setupGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleMapPan(_:)))
        panGesture.delegate = self
        mapView?.addGestureRecognizer(panGesture)
    }
    
    // when user drags the map, set flag ignoreMapRegionUpdates to true
    @objc func handleMapPan(_ gesture: UIPanGestureRecognizer) {
        if gesture.state == .began || gesture.state == .changed {
            mapViewModel.ignoreMapRegionUpdates = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // reset this flag every time screen opens
        mapViewModel.ignoreMapRegionUpdates = false
        mapViewModel.startLocationMonitoring()
    }
    
    private func setupSideMenu() {
        SideMenuManager.default.addPanGestureToPresent(toView: navigationController!.view)
        SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: view, forMenu: .left)
    }
    
    private func updateMapWithUserLocation(_ location: CLLocationCoordinate2D?) {
        guard mapViewModel.ignoreMapRegionUpdates == false else {
            return
        }
        
        if let region = mapViewModel.regionWithLocation(location) {
            mapView?.setRegion(region, animated: true)
        }
    }
    
    private func updateMapWithUserPathCoordinates(_ coordinates: [CLLocationCoordinate2D]) {
        guard let mapView = mapView else { return }
        mapView.removeOverlays(mapView.overlays)
        let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
        mapView.addOverlay(polyline)
    }
    
    @IBAction private func myLocationButtonTapped() {
        if permissionsManager.hasLocationPermission() {
            mapViewModel.ignoreMapRegionUpdates = false
            updateMapWithUserLocation(mapViewModel.currentLocation)
        } else {
            let alertController = UIAlertController(title: "Location Permission", message: "Please allow the app to access your location.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "No, thanks", style: .cancel, handler: nil))
            alertController.addAction(UIAlertAction(title: "Settings", style: .default, handler: { _ in
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }))
            present(alertController, animated: true)
        }
    }
    
    // Open Apple Maps with points A and B. A - current user's coordinates. B - center of Los Angeles
    @IBAction private func gotoAppleMapsButtonTapped() {
        guard let location = mapViewModel.currentLocation else {
            return
        }
        
        let sourceMapItem = mapViewModel.mapItem(location: location, text: "Current Location")

        let destinationCoordinate = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194) // San Francisco
        let destinationMapItem = mapViewModel.mapItem(location: destinationCoordinate, text: "San Francisco")

        MKMapItem.openMaps(with: [sourceMapItem, destinationMapItem], launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }
}

// MARK: UIGestureRecognizerDelegate's methods

extension MapViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

// MARK: MKMapViewDelegate's methods

extension MapViewController: MKMapViewDelegate {
    
    // drawing polylines
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: polyline)
            renderer.strokeColor = .systemBlue
            renderer.lineWidth = 5
            return renderer
        }
        return MKOverlayRenderer()
    }
    
}
