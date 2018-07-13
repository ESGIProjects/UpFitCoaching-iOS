//
//  ClientsList+TableView.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 16/06/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit

extension ClientsListController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "ClientCell", for: indexPath)
		
		let user = users[indexPath.row]
		cell.textLabel?.text = "\(user.firstName) \(user.lastName)"
		return cell
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return users.count
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		
		let user = users[indexPath.row]
		let clientController = ClientController()
		clientController.client = user
		navigationController?.pushViewController(clientController, animated: true)
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		if users.count > 0 {
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
