//
//  ContentViewController.swift
//  TaxiAdminApp
//
//  Created by Pavluk, Eugen on 28/05/2025.
//

import Foundation
import UIKit
import SideMenu

// Base Controller class for Info, Map and List view controllers
class ContentViewController: UIViewController {
    
    // handles opening of Left Menu upon tapping on Burger Menu button
    @IBAction func revealMenu() {
        if let leftMenuNavigationController = SideMenuManager.default.leftMenuNavigationController {
            present(leftMenuNavigationController, animated: true, completion: nil)
        }
    }
    
}
