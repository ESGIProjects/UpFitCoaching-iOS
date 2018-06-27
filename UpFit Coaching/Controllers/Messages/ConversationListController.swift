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
		
		// Updates websocket delegate
		MessagesDelegate.instance.delegate = self
		MessagesDelegate.instance.displayMode = .hide
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		// Updates websocket delegate
		MessagesDelegate.instance.delegate = nil
		MessagesDelegate.instance.displayMode = .display
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Setup layout
		title = "conversationListController_title".localized
		setupLayout()
		
		if #available(iOS 11.0, *) {
			navigationController?.navigationBar.prefersLargeTitles = true
			navigationItem.largeTitleDisplayMode = .always
		}
		
		// Register cell and notification
		tableView.register(ConversationListCell.self, forCellReuseIdentifier: "ConversationListCell")
		NotificationCenter.default.addObserver(self, selector: #selector(reloadConversations), name: .messagesDownloaded, object: nil)
	}
	
	// MARK: - Helpers
	
	@objc func reloadConversations() {
		guard let currentUser = currentUser else { return }
		
		let messages = Database().fetch(using: Message.all)
		conversations = Conversation.generateConversations(from: messages, for: currentUser)
		
		DispatchQueue.main.async { [weak self] in
			self?.tableView.reloadData()
		}
	}
}
