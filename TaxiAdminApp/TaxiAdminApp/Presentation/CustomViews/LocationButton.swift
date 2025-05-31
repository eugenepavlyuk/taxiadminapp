//
//  LocationButton.swift
//  TaxiAdminApp
//
//  Created by Pavluk, Eugen on 29/05/2025.
//

import Foundation
import UIKit

// Custom button for MyLocation and GoToAppleMaps in Map screen
class LocationButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = self.bounds.width / 2
        layer.masksToBounds = true
    }
    
}
