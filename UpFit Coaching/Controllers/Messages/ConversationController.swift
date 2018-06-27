//
//  ConversationController.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 13/02/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit
import Starscream
import PKHUD

class ConversationController: UIViewController {
	
	// MARK: - UI
	
	var collectionView: UICollectionView!
	var messageBarView: MessageBarView!
	var messageBarViewBottomConstraint: NSLayoutConstraint!
	
	// MARK: - Data
	
	let currentUser = Database().getCurrentUser()
	var otherUser: User?
	
	var messages = [Message]()
	let decoder = JSONDecoder.withDate
	let encoder = JSONEncoder.withDate
	
	// MARK: - UIViewController
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		guard let otherUser = otherUser else { return }
		
		// Setting up layout
		title = "\(otherUser.firstName) \(otherUser.lastName)"
		edgesForExtendedLayout = []
		//view.backgroundColor = .white
		setupLayout()
		
		if #available(iOS 11.0, *) {
			navigationItem.largeTitleDisplayMode = .never
		}
		
		// Register cell and notification
		collectionView.register(MessageCell.self, forCellWithReuseIdentifier: "MessageCell")
		NotificationCenter.default.addObserver(self, selector: #selector(loadMessages), name: .messagesDownloaded, object: nil)
		
		loadMessages()
		
	}
	
	@objc func loadMessages() {
		guard let currentUser = currentUser else { return }
		guard let otherUser = otherUser else { return }
		
		messages = Database().getMessages(between: currentUser, and: otherUser)
		
		DispatchQueue.main.async { [weak self] in
			self?.collectionView.reloadData()
			self?.scrollToBottom(animated: false)
		}
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		addKeyboardObservers()
		
		// Updates websocket delegate
		MessagesDelegate.instance.delegate = self
		MessagesDelegate.instance.displayMode = .hide
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		removeKeyboardObservers()
		
		// Updates websocket delegate
		MessagesDelegate.instance.delegate = nil
		MessagesDelegate.instance.displayMode = .display
	}
	
	// MARK: - Helpers
	
	func scrollToBottom(animated: Bool) {
		collectionView.setNeedsLayout()
		collectionView.layoutIfNeeded()
		
		let bottomOffset = CGRect(x: 0, y: collectionView.contentSize.height - 1, width: collectionView.contentSize.width, height: 1)
		collectionView.scrollRectToVisible(bottomOffset, animated: animated)
	}
	
	func addKeyboardObservers() {
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: .UIKeyboardWillHide, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: .UIKeyboardWillChangeFrame, object: nil)
	}
	
	func removeKeyboardObservers() {
		NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
		NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
		NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillChangeFrame, object: nil)
	}
	
	// MARK: - Actions
	
	@objc func sendButtonTapped(_ sender: UIButton) {
		guard let currentUser = currentUser else { return }
		guard let otherUser = otherUser else { return }
		
		// Check if the message is not empty
		guard !messageBarView.isMessageEmpty else { return }
		
		if let messageText = messageBarView.textView.text {
			let message = Message(sender: currentUser, receiver: otherUser, date: Date(), content: messageText)
			messages.append(message)
			
			// Send through socket
			if let data = try? encoder.encode(message) {
				MessagesDelegate.instance.socket?.write(data: data)
				
				let database = Database()
				let temporaryMessageID = database.reverseNext(type: MessageObject.self, of: "messageID") - 1
				
				message.messageID = temporaryMessageID
				database.createOrUpdate(model: message, with: MessageObject.init)
			}
		}
		
		// Empty the text view
		messageBarView.textView.text = ""
		
		// Reload UI
		collectionView.reloadData()
		scrollToBottom(animated: true)
	}
	
	// MARK: - Keyboard management
	
	@objc func keyboardWillShow(notification: NSNotification) {
		guard let userInfo = notification.userInfo else { return }
		guard let animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double else { return }
		guard let keyboardEndFrame = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue else { return }
		
		// Determines keyboard height
		var keyboardHeight = keyboardEndFrame.cgRectValue.height
		
		if #available(iOS 11.0, *) {
			keyboardHeight -= view.safeAreaInsets.bottom
		}
		
		// Removes tab bar height if not hidden
		if let tabBar = tabBarController?.tabBar, !tabBar.isHidden {
			messageBarViewBottomConstraint.constant = -keyboardHeight + tabBar.bounds.height
		} else {
			messageBarViewBottomConstraint.constant = -keyboardHeight
		}
		
		// Insets the collection view
		collectionView.contentInset.bottom = messageBarView.frame.height + keyboardHeight
		collectionView.scrollRectToVisible(CGRect(x: 0, y: collectionView.contentSize.height - 1, width: collectionView.contentSize.width, height: 1), animated: true)
		
		UIView.animate(withDuration: animationDuration) { [weak self] in
			self?.view.layoutIfNeeded()
		}
	}
	
	@objc func keyboardWillHide(notification: NSNotification) {
		guard let userInfo = notification.userInfo else { return }
		guard let animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double else { return }
		
		messageBarViewBottomConstraint.constant = 0.0
		collectionView.contentInset.bottom = messageBarView.frame.height
		
		UIView.animate(withDuration: animationDuration) { [weak self] in
			self?.view.layoutIfNeeded()
		}
	}
}
