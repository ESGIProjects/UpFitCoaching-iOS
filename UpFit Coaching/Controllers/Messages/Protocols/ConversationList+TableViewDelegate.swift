//
//  ConversationList+TableViewDelegate.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 10/05/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

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
