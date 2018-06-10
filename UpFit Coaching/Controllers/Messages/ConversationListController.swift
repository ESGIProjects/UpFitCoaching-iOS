//
//  ConversationListController.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 20/02/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit
import RealmSwift
import PKHUD

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
		MessagesDelegate.instance.displayMode = .hide
		
		// Set foreground observer
		NotificationCenter.default.addObserver(self, selector: #selector(moveToForeground), name: .UIApplicationWillEnterForeground, object: nil)
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		// Updates websocket delegate
		MessagesDelegate.instance.delegate = nil
		MessagesDelegate.instance.displayMode = .display
		
		// Remove foreground observer
		NotificationCenter.default.removeObserver(self, name: .UIApplicationWillEnterForeground, object: nil)
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
		
		// Register cell and notification
		tableView.register(ConversationListCell.self, forCellReuseIdentifier: "ConversationListCell")
		NotificationCenter.default.addObserver(self, selector: #selector(messagesDownloaded), name: .messagesDownloaded, object: nil)
		
		// Download all messages
		downloadMessages()
	}
	
	// MARK: - Helpers

	func downloadMessages() {
		guard let currentUser = currentUser else { return }
		
		DispatchQueue.main.async {
			HUD.show(.progress)
		}
		
		Network.getMessages(for: currentUser) { data, response, _ in
			guard let data = data else { return }
			
			if Network.isSuccess(response: response, successCode: 200) {
				// Decode messages list
				let decoder = JSONDecoder.withDate
				guard let messages = try? decoder.decode([Message].self, from: data) else { return }
				
				// Save messages
				let database = Database()
				database.deleteAll(of: MessageObject.self)
				database.createOrUpdate(models: messages, with: MessageObject.init)
				
				// Post a notification telling it's done
				NotificationCenter.default.post(name: .messagesDownloaded, object: nil, userInfo: nil)
			}
			
			DispatchQueue.main.async {
				HUD.hide()
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
	
	@objc func moveToForeground() {
		downloadMessages()
	}
}
