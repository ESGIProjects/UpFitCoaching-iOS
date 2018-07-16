//
//  ClientsListController.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 16/06/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
// Version 1.0

import UIKit

class ClientsListController: UIViewController {
	
	var tableView: UITableView!
	let searchController = UISearchController(searchResultsController: nil)
	
	let currentUser = Database().getCurrentUser()
	var users = [User]()
	var filteredUsers = [User]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = "clientsListController_title".localized
		view.backgroundColor = .background
		setupLayout()
		
		if #available(iOS 11.0, *) {
			navigationController?.navigationBar.prefersLargeTitles = true
			navigationItem.largeTitleDisplayMode = .always
			navigationItem.hidesSearchBarWhenScrolling = false
		}
		
		// Register cell
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ClientCell")
		
		// Search Controller
		searchController.searchBar.tintColor = .white
		searchController.searchBar.barTintColor = .white
		
		if let textField = searchController.searchBar.value(forKey: "searchField") as? UITextField,
			let backgroundView = textField.subviews.first {
			backgroundView.backgroundColor = .white
			backgroundView.layer.cornerRadius = 10
			backgroundView.clipsToBounds = true
		}
		
		searchController.searchResultsUpdater = self
		searchController.obscuresBackgroundDuringPresentation = false
		searchController.searchBar.placeholder = "searchPlaceholder".localized
		definesPresentationContext = true
		
		if #available(iOS 11.0, *) {
			navigationItem.searchController = searchController
		} else {
			tableView.tableHeaderView = searchController.searchBar
		}
		
		// Fetch users
		users = Database().fetch(using: User.all)
		guard let currentUser = currentUser,
			let index = users.index(of: currentUser) else { return }
		
		users.remove(at: index)
	}

}
