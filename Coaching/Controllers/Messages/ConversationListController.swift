//
//  ConversationListController.swift
//  Coaching
//
//  Created by Jason Pierna on 20/02/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit
import RealmSwift

extension Notification.Name {
	static let test = Notification.Name("test")
}

class ConversationListController: UIViewController {
	
	// MARK: - UI
	
	lazy var tableView = UI.tableView(delegate: self, dataSource: self)

	// MARK: - Data
	
	lazy var conversations = Database().fetch(using: Conversation.all)
	
	// MARK: - UIViewController
	
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
		
//		NotificationCenter.default.addObserver(self, selector: #selector(testNotification), name: .test, object: nil)
		
		if conversations.count == 0 {
			let database = Database()
			
			// Create the conversation object
			let conversation = Conversation(conversationID: database.next(type: ConversationObject.self, of: "conversationID"), name: "Jason", message: "Miaou")
			database.createOrUpdate(model: conversation, with: ConversationObject.init)
			
			// Reload data
			conversations = database.fetch(using: Conversation.all)
			tableView.reloadData()
		}
		
		downloadMessages()
	}
	
	// MARK: - Helpers
	
	private func setupLayout() {
		// Layout the table view
		view.addSubview(tableView)
		
		let constraints = UI.getConstraints(for: self)
		NSLayoutConstraint.activate(constraints)
	}

	private func downloadMessages() {
		print(#function)
		
		guard let currentUser = Database().getCurrentUser() else { return }
		Network.getConversation(between: 1, and: currentUser.userID) { data, response, _ in
			
			guard let response = response as? HTTPURLResponse,
				let data = data else { return}
			
			// Print the HTTP status code
			print("Status code:", response.statusCode)
			
			// Creating the JSON decoder
			let dateFormatter = DateFormatter()
			dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
			
			let decoder = JSONDecoder()
			decoder.dateDecodingStrategy = .formatted(dateFormatter)
			
			// If the fetch is a success
			if response.statusCode == 200 {
				// Decode messages list
				guard let messages = try? decoder.decode([Message].self, from: data) else { return }
				print(messages.count, "messages")
				
				// Save messages
				let database = Database()
				database.deleteAll(of: MessageObject.self)
				database.createOrUpdate(models: messages, with: MessageObject.init)
				
				// Post a notification telling its done
				NotificationCenter.default.post(name: NSNotification.Name("test"), object: nil, userInfo: nil)
			}
		}
	}
}

// MARK: - UITableViewDataSource
extension ConversationListController: UITableViewDataSource {
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
		
		cell.nameLabel.text = conversations[indexPath.row].name
		cell.messageLabel.text = conversations[indexPath.row].message
		
		return cell
	}
}

// MARK: - UITableViewDelegate
extension ConversationListController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		
		let conversationViewController = ConversationController()
		conversationViewController.hidesBottomBarWhenPushed = true
		conversationViewController.title = conversations[indexPath.row].name

		navigationController?.pushViewController(conversationViewController, animated: true)
	}
}
