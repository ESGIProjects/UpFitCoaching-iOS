//
//  ConversationListController.swift
//  Coaching
//
//  Created by Jason Pierna on 20/02/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit

class ConversationListController: UIViewController {
	
	lazy var tableView = UI.tableView(delegate: self, dataSource: self)
	
	var conversations: [Conversation] = [
		Conversation(name: "Jason Pierna", message: "debug_longMessage".localized),
		Conversation(name: "Kévin Le", message: "debug_shortMessage".localized),
		Conversation(name: "Maeva Malih", message: "debug_shortMessage".localized)
	]
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = "conversationList_title".localized
		
		if #available(iOS 11.0, *) {
			navigationController?.navigationBar.prefersLargeTitles = true
			navigationItem.largeTitleDisplayMode = .always
		}
		
		tableView.estimatedRowHeight = 100.0
		tableView.rowHeight = UITableViewAutomaticDimension
		tableView.register(ConversationListCell.self, forCellReuseIdentifier: "ConversationListCell")
		
		setupLayout()
	}
	
	private func setupLayout() {
		// Layout the table view
		view.addSubview(tableView)
		
		let constraints = UI.getConstraints(for: self)
		NSLayoutConstraint.activate(constraints)
	}
}

extension ConversationListController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return conversations.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell: ConversationListCell!
		
		if let dequeueCell = tableView.dequeueReusableCell(withIdentifier: "ConversationListCell", for: indexPath) as? ConversationListCell {
			cell = dequeueCell
		} else {
			cell = ConversationListCell(frame: .zero)
		}
		
		cell.accessoryType = .disclosureIndicator
		
		cell.nameLabel.text = conversations[indexPath.row].name
		cell.messageLabel.text = conversations[indexPath.row].message
		
		return cell
	}
}

extension ConversationListController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		
		let conversationViewController = ConversationController()
		conversationViewController.hidesBottomBarWhenPushed = true
		conversationViewController.title = conversations[indexPath.row].name

		navigationController?.pushViewController(conversationViewController, animated: true)
	}
}
