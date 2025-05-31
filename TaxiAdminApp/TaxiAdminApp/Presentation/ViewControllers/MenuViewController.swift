//
//  MenuViewController.swift
//  TaxiAdminApp
//
//  Created by Pavluk, Eugen on 28/05/2025.
//

import Foundation
import UIKit

/*
 * Menu screen with for Left Side Menu (Burger Menu)
 * Most of details are hidden in storyboard, for example:
 * - colors;
 * - table view cell;
 * - transitions to other screen
 * - header with avatar and name
 */
class MenuViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        self.tableView.contentInsetAdjustmentBehavior = .never
    }
    
}

// MARK: UITableViewDelegate's methods

extension MenuViewController {
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
}
