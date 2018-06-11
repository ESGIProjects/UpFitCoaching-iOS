//
//  Thread+TableView.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 11/06/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit

extension ThreadController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return posts.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell: PostCell
		
		if let postCell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as? PostCell {
			cell = postCell
		} else {
			cell = PostCell(style: .default, reuseIdentifier: "PostCell")
		}
		
		let post = posts[indexPath.row]
		
		cell.userNameLabel.text = "\(post.user.firstName) \(post.user.lastName)"
		cell.dateLabel.text = dateFormatter.string(from: post.date)
		cell.contentLabel.text = post.content
		
		return cell
	}
}

extension ThreadController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}
}
