//
//  ListViewController.swift
//  TaxiAdminApp
//
//  Created by Pavluk, Eugen on 28/05/2025.
//

import Foundation
import UIKit
import Resolver
import SDWebImage

/*
 * List Screen shows a list of photos with picture, id, and title
 */
class ListViewController: ContentViewController {
    
    // UI Elements
    @IBOutlet private weak var tableView: UITableView?
    
    // Dependencies
    @LazyInjected private var listViewModel: ListViewModel
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRefreshControl()
    }
    
    private func setupRefreshControl() {
        tableView?.refreshControl = UIRefreshControl()
        tableView?.refreshControl?.addTarget(self, action: #selector(reloadData), for: .valueChanged)
    }
    
    @objc private func reloadData() {
        Task {
            await listViewModel.fetchPhotos()
            tableView?.reloadData()
            tableView?.refreshControl?.endRefreshing()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        triggerRefresh()
    }
    
    func triggerRefresh() {
        tableView?.refreshControl?.beginRefreshing()

        // show refresh control automatically
        tableView?.setContentOffset(CGPoint(x: 0, y: -(tableView?.refreshControl?.frame.size.height ?? 0)), animated: false)

        reloadData()
    }
}

// MARK: UITableViewDataSource's methods

extension ListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listViewModel.numberOfPhotos()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoTableViewCellIdentifier", for: indexPath) as? PhotoTableViewCell else {
            fatalError("Check tableView cell registration in storyboard")
        }
            
        let photoViewModel = listViewModel.photoViewModel(at: indexPath.row)
        cell.photoId?.text = photoViewModel.id
        cell.photoTitle?.text = photoViewModel.title
        
        cell.activityIndicatorView?.startAnimating()
        cell.photoImageView?.sd_setImage(with: URL(string: photoViewModel.thumbnailUrl)!) { image, _, _, _ in
            cell.photoImageView?.image = image
            cell.activityIndicatorView?.stopAnimating()
        }
        return cell
    }
}

// MARK: UITableViewDelegate's methods

extension ListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

