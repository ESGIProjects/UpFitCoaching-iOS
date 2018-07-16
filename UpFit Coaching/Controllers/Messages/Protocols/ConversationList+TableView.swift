//
//  ConversationList+DataSource.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 10/05/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
// Version 1.0

import UIKit

extension ConversationListController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		
		let user = conversations[indexPath.row].user
		
		let conversationController = ConversationController()
		conversationController.hidesBottomBarWhenPushed = true
		conversationController.title = "\(user.firstName) \(user.lastName)"
		conversationController.otherUser = user
		
		navigationController?.pushViewController(conversationController, animated: true)
	}
}

extension ConversationListController: UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		if conversations.count > 0 {
			tableView.separatorColor = .gray
			tableView.backgroundView = nil
			
			return 1
		} else {
			let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
			messageLabel.text = "noMessagesYet".localized
			messageLabel.textColor = .gray
			messageLabel.numberOfLines = 0
			messageLabel.textAlignment = .center
			messageLabel.font = UIFont.boldSystemFont(ofSize: 17.0)
			messageLabel.sizeToFit()
			
			tableView.separatorColor = .clear
			tableView.backgroundView = messageLabel
			
			return 0
		}
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return conversations.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell: ConversationListCell
		
		if let dequeueCell = tableView.dequeueReusableCell(withIdentifier: "ConversationListCell", for: indexPath) as? ConversationListCell {
			cell = dequeueCell
		} else {
			cell = ConversationListCell(frame: .zero)
		}
		
		cell.accessoryType = .disclosureIndicator
		
		let conversation = conversations[indexPath.row]
		
		cell.circleLabel.text = conversation.user.firstName.prefix(1).uppercased()
		cell.nameLabel.text = "\(conversation.user.firstName) \(conversation.user.lastName)"
		cell.messageLabel.text = conversation.message.content
		
		return cell
	}
}
