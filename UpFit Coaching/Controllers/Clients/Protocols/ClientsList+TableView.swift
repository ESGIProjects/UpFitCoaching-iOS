//
//  ClientsList+TableView.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 16/06/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
// Version 1.0

import UIKit

extension ClientsListController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "ClientCell", for: indexPath)
		
		let user = isFiltering ? filteredUsers[indexPath.row] : users[indexPath.row]
		cell.textLabel?.text = "\(user.firstName) \(user.lastName)"
		return cell
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return isFiltering ? filteredUsers.count : users.count
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		
		let user = isFiltering ? filteredUsers[indexPath.row] : users[indexPath.row]
		let clientController = ClientController()
		clientController.client = user
		navigationController?.pushViewController(clientController, animated: true)
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		let rowCount = isFiltering ? filteredUsers.count : users.count
		
		if rowCount > 0 {
			tableView.separatorColor = .gray
			tableView.backgroundView = nil
			
			return 1
		} else {
			let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
			messageLabel.text = "noClientYet".localized
			messageLabel.textColor = .gray
			messageLabel.numberOfLines = 0
			messageLabel.textAlignment = .center
			messageLabel.font = .boldSystemFont(ofSize: 17.0)
			messageLabel.sizeToFit()
			
			tableView.separatorColor = .clear
			tableView.backgroundView = messageLabel
			
			return 0
		}
	}
}

extension ClientsListController: UISearchResultsUpdating {
	var isSearchBarEmpty: Bool {
		return searchController.searchBar.text?.isEmpty ?? true
	}
	
	var isFiltering: Bool {
		return searchController.isActive && !isSearchBarEmpty
	}
	
	func updateSearchResults(for searchController: UISearchController) {
		guard let searchText = searchController.searchBar.text else { return }
		
		filteredUsers = users.filter({ user -> Bool in
			return user.firstName.lowercased()
				.appending(" ")
				.appending(user.lastName.lowercased())
				.contains(searchText.lowercased())
		})
		
		tableView.reloadData()
	}
}
