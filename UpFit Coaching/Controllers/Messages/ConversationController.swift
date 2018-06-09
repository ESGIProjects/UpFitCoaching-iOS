//
//  ConversationController.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 13/02/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit
import Starscream

class ConversationController: UIViewController {
	
	// MARK: - UI
	
	var collectionView: UICollectionView!
	var messageBarView: MessageBarView!
	var messageBarViewBottomConstraint: NSLayoutConstraint!
	
	// MARK: - User info
	
	let currentUser = Database().getCurrentUser()
	var otherUser: User? {
		didSet {
			guard let otherUser = otherUser else { return }
			title = "\(otherUser.firstName) \(otherUser.lastName)"
		}
	}
	
	lazy var messages: [Message] = {
		guard let currentUser = currentUser else { return [] }
		guard let otherUser = otherUser else { return [] }
		
		return Database().getMessages(between: currentUser, and: otherUser)
	}()
	
	// Formatters
	let decoder = JSONDecoder.withDate
	let encoder = JSONEncoder.withDate
	
	// MARK: - UIViewController
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Layout
		view.backgroundColor = .white
		edgesForExtendedLayout = []
		
		if #available(iOS 11.0, *) {
			navigationItem.largeTitleDisplayMode = .never
		}
		
		// Setting up
		setUIComponents()
		collectionView.register(MessageCell.self, forCellWithReuseIdentifier: "MessageCell")
		
		setupLayout()
		addObservers()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		// Updates websocket delegate
		MessagesDelegate.instance.delegate = self
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		removeObservers()
		
		// Updates websocket delegate
		MessagesDelegate.instance.delegate = nil
	}
	
	// MARK: - Helpers
	
	func scrollToBottom(animated: Bool) {
		collectionView.setNeedsLayout()
		collectionView.layoutIfNeeded()
		
		if animated {
			let bottomOffset = CGRect(x: 0, y: collectionView.contentSize.height - 1, width: collectionView.contentSize.width, height: 1)
			collectionView.scrollRectToVisible(bottomOffset, animated: true)
		} else {
			let bottomOffset = CGPoint(x: 0, y: collectionView.contentSize.height)
			collectionView.setContentOffset(bottomOffset, animated: true)
		}
	}
	
	func addObservers() {
		// Keyboard observers
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: .UIKeyboardWillHide, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: .UIKeyboardWillChangeFrame, object: nil)
		
		// Orientaton observer
		NotificationCenter.default.addObserver(self, selector: #selector(orientationDidChange), name: .UIDeviceOrientationDidChange, object: nil)
	}
	
	func removeObservers() {
		// Remove every observers
		NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
		NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
		NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillChangeFrame, object: nil)
		NotificationCenter.default.removeObserver(self, name: .UIDeviceOrientationDidChange, object: nil)
	}
	
	// MARK: - Actions
	
	@objc func orientationDidChange() {
		collectionView.collectionViewLayout.invalidateLayout()
	}
	
	@objc func sendButtonTapped(_ sender: UIButton) {
		// Check if the message is not empty
		guard !messageBarView.isMessageEmpty else { print("Message empty"); return }
		guard let currentUser = currentUser else { return }
		guard let otherUser = otherUser else { return }
		
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
	
	@objc func keyboardWillShow(notification: NSNotification) {
		guard let userInfo = notification.userInfo else { return }
		guard let animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double else { return }
		guard let keyboardEndFrame = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue else { return }
		guard let tabBar = tabBarController?.tabBar else { return }
		
		// Determines keyboard height
		var keyboardHeight = keyboardEndFrame.cgRectValue.height
		
		if #available(iOS 11.0, *) {
			keyboardHeight -= view.safeAreaInsets.bottom
		}
		
		// Removes tab bar height if not hidden
		if tabBar.isHidden {
			messageBarViewBottomConstraint.constant = -keyboardHeight
		} else {
			messageBarViewBottomConstraint.constant = -keyboardHeight + tabBar.bounds.height
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
