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
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "ThreadCell", for: indexPath)
		
		let thread = threads[indexPath.row]
		cell.textLabel?.text = thread.title
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return threads.count
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
