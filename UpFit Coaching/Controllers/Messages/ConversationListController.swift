//
//  ConversationListController.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 20/02/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit
import RealmSwift

class ConversationListController: UIViewController {
	
	// MARK: - UI
	
	var tableView: UITableView!

	// MARK: - Data
	
	let currentUser = Database().getCurrentUser()
	var conversations = [Conversation]()
	
	// MARK: - UIViewController
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		// Reload conversations
		reloadConversations()
		tableView.reloadData()
		
		// Updates websocket delegate
		MessagesDelegate.instance.delegate = self
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		// Updates websocket delegate
		MessagesDelegate.instance.delegate = UIApplication.shared.delegate as? AppDelegate
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Setup layout
		title = "conversationList_title".localized
		setupLayout()
		
		if #available(iOS 11.0, *) {
			navigationController?.navigationBar.prefersLargeTitles = true
			navigationItem.largeTitleDisplayMode = .always
		}
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(startConversation))
		
		// Register cell and notification
		tableView.register(ConversationListCell.self, forCellReuseIdentifier: "ConversationListCell")
		NotificationCenter.default.addObserver(self, selector: #selector(messagesDownloaded), name: .messagesDownloaded, object: nil)
		
		// Download all messages
		downloadMessages()
	}
	
	// MARK: - Helpers

	func downloadMessages() {
		guard let currentUser = currentUser else { return }
		
		Network.getMessages(for: currentUser) { data, response, _ in
			guard let data = data else { return }
			
			if Network.isSuccess(response: response, successCode: 200) {
				// Creating the JSON decoder
				let dateFormatter = DateFormatter()
				dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
				
				let decoder = JSONDecoder()
				decoder.dateDecodingStrategy = .formatted(dateFormatter)
				
				// Decode messages list
				guard let messages = try? decoder.decode([Message].self, from: data) else { return }
				
				// Save messages
				let database = Database()
				database.deleteAll(of: MessageObject.self)
				database.createOrUpdate(models: messages, with: MessageObject.init)
				
				// Post a notification telling its done
				NotificationCenter.default.post(name: .messagesDownloaded, object: nil, userInfo: nil)
			}
		}
	}
	
	func reloadConversations() {
		guard let currentUser = currentUser else { return }
		
		let messages = Database().fetch(using: Message.all)
		conversations = Conversation.generateConversations(from: messages, for: currentUser)
	}
	
	// MARK: - Actions
	
	@objc func messagesDownloaded() {
		reloadConversations()
		
		DispatchQueue.main.async { [weak self] in
			self?.tableView.reloadData()
		}
	}
	
	@objc func startConversation() {
		print("Start conversation !!")
	}
}
