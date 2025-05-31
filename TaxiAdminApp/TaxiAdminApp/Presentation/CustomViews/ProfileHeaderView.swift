//
//  ProfileHeaderView.swift
//  TaxiAdminApp
//
//  Created by Pavluk, Eugen on 29/05/2025.
//

import Foundation
import UIKit

// Custom view for Profile Header in Menu with avatar and full name
class ProfileHeaderView: UIView {
    
    // UI Elements
    @IBOutlet var avatarImageView: UIImageView?
        
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let avatarImageView {
            // clip with radius
            avatarImageView.layer.cornerRadius = avatarImageView.bounds.width / 2
        }
    }
    
}
