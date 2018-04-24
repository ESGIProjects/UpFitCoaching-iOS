//
//  ConversationListController.swift
//  Coaching
//
//  Created by Jason Pierna on 20/02/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit
import RealmSwift

class ConversationListController: UIViewController {
	
	// MARK: - UI
	
	lazy var tableView = UI.tableView(delegate: self, dataSource: self)

	// MARK: - Data
	
	let currentUser = Database().getCurrentUser()	
	var conversations = [Conversation]()
	
	// MARK: - UIViewController
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		guard let currentUser = currentUser else { return }
		
		let messages = Database().fetch(using: Message.all)
		conversations = Conversation.generateConversations(from: messages, for: currentUser)
		
		tableView.reloadData()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Layout
		title = "conversationList_title".localized
		
		if #available(iOS 11.0, *) {
			navigationController?.navigationBar.prefersLargeTitles = true
			navigationItem.largeTitleDisplayMode = .always
		}
		
		setupLayout()
		
		// Add button on navigation bar
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(startConversation))
		
		// Setting up table view
		tableView.estimatedRowHeight = 100.0
		tableView.rowHeight = UITableViewAutomaticDimension
		tableView.register(ConversationListCell.self, forCellReuseIdentifier: "ConversationListCell")
		
		// Add observer
		NotificationCenter.default.addObserver(self, selector: #selector(messagesDownloaded), name: .messagesDownloaded, object: nil)
		
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
		guard let currentUser = currentUser else { return }
		
		Network.getMessages(for: currentUser.userID) { data, response, _ in
			
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
				NotificationCenter.default.post(name: .messagesDownloaded, object: nil, userInfo: nil)
			}
		}
	}
	
	// MARK: - Actions
	@objc func messagesDownloaded() {
		guard let currentUser = currentUser else { return }
		
		// Reload conversations
		let messages = Database().fetch(using: Message.all)
		conversations = Conversation.generateConversations(from: messages, for: currentUser)
		
		DispatchQueue.main.async { [weak self] in
			self?.tableView.reloadData()
		}
	}
	
	@objc func startConversation() {
		print("Start conversation !!")
	}
}

// MARK: - UITableViewDataSource
extension ConversationListController: UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		if conversations.count > 0 {
			tableView.separatorColor = .gray
			tableView.backgroundView = nil
			
			return 1
		} else {
			let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
			messageLabel.text = "You have no messages yet.\nStart a conversation!"
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
		
		cell.nameLabel.text = "\(conversation.user.firstName) \(conversation.user.lastName)"
		cell.messageLabel.text = conversation.message.content
		
		return cell
	}
}

// MARK: - UITableViewDelegate
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
