//
//  Forum+TableView.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 07/06/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit

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
		cell.infoLabel.text = "Dernier message hier, 20:10 par Jason Pierna"
		
		return cell
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
