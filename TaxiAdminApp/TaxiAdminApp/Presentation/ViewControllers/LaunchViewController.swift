//
//  LaunchViewController.swift
//  TaxiAdminApp
//
//  Created by Pavluk, Eugen on 27/05/2025.
//

import UIKit
import SideMenu
import CoreGraphics
import Resolver

/*
 * Launch Screen which shows animation
 */
class LaunchViewController: UIViewController {
    
    // UI elements
    @IBOutlet private weak var logoImageView: UIImageView?
    
    // Dependencies
    @Injected private var permissionsManager: PermissionsManager
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup Left Side Menu
        setupSideMenu()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Start animation of Logo when Launch screen appears
        startAnimation()
    }
    
    private func setupSideMenu() {
        // Define the menus
        SideMenuManager.default.leftMenuNavigationController = storyboard?.instantiateViewController(withIdentifier: "SideMenuNavigationController") as? SideMenuNavigationController
        
        var settings = SideMenuSettings()
        settings.pushStyle = .replace
        settings.presentationStyle = .menuSlideIn
        settings.presentationStyle.onTopShadowOpacity = 0.3
        settings.presentationStyle.presentingEndAlpha = 0.80
        settings.menuWidth = UIScreen.main.bounds.width * 0.8
        
        settings.allowPushOfSameClassTwice = true
        SideMenuManager.default.leftMenuNavigationController?.settings = settings
    }
    
    private func startAnimation() {
        UIView.animate(withDuration: 3.0, animations: {
            if let logoImageView = self.logoImageView {
                logoImageView.alpha = 0.0
                logoImageView.transform = CGAffineTransform(scaleX: 5, y: 5)
            }
        }) { [weak self] _ in
            self?.showMainScreen()
        }
    }
    
    private func showMainScreen() {
        Resolver.instantiateBeforehand()
        performSegue(withIdentifier: "MainNavigationSegue", sender: nil)
        askForPermissions()
    }
    
    private func askForPermissions() {
        permissionsManager.requestPermissions()
    }
}

