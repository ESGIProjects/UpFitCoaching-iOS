//
//  Forum+TableView.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 07/06/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
// Version 1.0

import UIKit
import RealmSwift

extension ForumController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var cell: ThreadCell
		
		if let threadCell = tableView.dequeueReusableCell(withIdentifier: "ThreadCell", for: indexPath) as? ThreadCell {
			cell = threadCell
		} else {
			cell = ThreadCell(style: .default, reuseIdentifier: "ThreadCell")
		}
		
		let thread = threads[indexPath.row]
		
		cell.titleLabel.text = thread.title
		
		if let lastUpdated = thread.lastUpdated,
			let lastUser = thread.lastUser {
			cell.infoLabel.text = "thread_subtitle".localized(with: dateFormatter.string(from: lastUpdated), lastUser.firstName, lastUser.lastName)
		}
		
		return cell
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		if threads.count > 0 {
			tableView.separatorColor = .gray
			tableView.backgroundView = nil
			
			return 1
		} else {
			let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
			messageLabel.text = "noThreadYet".localized
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
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return threads.count
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableViewAutomaticDimension
	}
}

extension ForumController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		let thread = threads[indexPath.row]
		
		let threadController = ThreadController()
		threadController.thread = thread
		navigationController?.pushViewController(threadController, animated: true)
	}
}
