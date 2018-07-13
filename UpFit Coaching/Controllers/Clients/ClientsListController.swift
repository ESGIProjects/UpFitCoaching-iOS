//
//  ClientsListController.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 16/06/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit

class ClientsListController: UIViewController {
	
	var tableView: UITableView!
	
	let currentUser = Database().getCurrentUser()
	var users = [User]()
	
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
		
		// Fetch users
		users = Database().fetch(using: User.all)
		guard let currentUser = currentUser,
			let index = users.index(of: currentUser) else { return }
		
		users.remove(at: index)
	}
}
