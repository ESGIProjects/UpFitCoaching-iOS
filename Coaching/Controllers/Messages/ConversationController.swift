//
//  ConversationController.swift
//  Coaching
//
//  Created by Jason Pierna on 13/02/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit
import Starscream

class ConversationController: UIViewController {
	
	// MARK: - UI
	
	lazy var collectionView = UI.collectionView(delegate: nil, dataSource: self, layoutDelegate: self)
	lazy var messageBarView = UI.messageBarView(self, action: #selector(sendButtonTapped(_:)))
	
	private var messageBarViewBottomConstraint: NSLayoutConstraint!
	
	// MARK: - User info
	
	var currentUser = Database().getCurrentUser()
	lazy var messages: [Message] = {
		guard let currentUser = currentUser else { return [Message]() }
		return Database().getMessages(between: currentUser.userID, and: 1)
	}()
	
	// MARK: - Sockets
	var socket: WebSocket?
	
	// Formatters
	
	let dateFormatter = DateFormatter()
	let decoder = JSONDecoder()
	let encoder = JSONEncoder()
	
	// MARK: - UIViewController
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Setting up
		collectionView.register(MessageCell.self, forCellWithReuseIdentifier: "MessageCell")
		dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
		decoder.dateDecodingStrategy = .formatted(dateFormatter)
		encoder.dateEncodingStrategy = .formatted(dateFormatter)
		
		// Layout
		view.backgroundColor = .white
		edgesForExtendedLayout = []
	
		if #available(iOS 11.0, *) {
			navigationItem.largeTitleDisplayMode = .never
		}
		
		setupLayout()
		
		// Keyboard observers
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: .UIKeyboardWillHide, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: .UIKeyboardWillChangeFrame, object: nil)
		
		// Orientaton observer
		NotificationCenter.default.addObserver(self, selector: #selector(orientationDidChange), name: .UIDeviceOrientationDidChange, object: nil)
		
		// Setting up the websocket
		guard let currentUser = currentUser else { return }
		
		if let webSocketURL = URL(string: "ws://212.47.234.147/ws?id=\(currentUser.userID)&type=0") {
			socket = WebSocket(url: webSocketURL, protocols: ["message"])
			socket?.delegate = self
			socket?.connect()
		}
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		// Remove every observers
		NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
		NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
		NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillChangeFrame, object: nil)
		NotificationCenter.default.removeObserver(self, name: .UIDeviceOrientationDidChange, object: nil)
		
		// Disconnect websocket
		socket?.disconnect()
	}
	
	// MARK: - Helpers
	
	func setupLayout() {
		view.addSubview(collectionView)
		view.addSubview(messageBarView)
		
		if #available(iOS 11.0, *) {
			messageBarViewBottomConstraint = messageBarView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
		} else {
			messageBarViewBottomConstraint = messageBarView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
		}
		
		let constraints = UI.getConstraints(for: self)
		NSLayoutConstraint.activate(constraints)
		messageBarViewBottomConstraint.isActive = true
		
		// Update scroll view insets
		messageBarView.setNeedsLayout()
		messageBarView.layoutIfNeeded()
		
		collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: messageBarView.frame.height, right: 0)
		collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: messageBarView.frame.height, right: 0)
		
		// Scroll to bottom
		collectionView.setNeedsLayout()
		collectionView.layoutIfNeeded()
		
		let bottomOffset = CGPoint(x: 0, y: collectionView.contentSize.height)
		collectionView.setContentOffset(bottomOffset, animated: true)
	}
	
	func scrollToBottom() {
		collectionView.setNeedsLayout()
		collectionView.layoutIfNeeded()
		
		collectionView.scrollRectToVisible(CGRect(x: 0, y: collectionView.contentSize.height - 1, width: collectionView.contentSize.width, height: 1), animated: true)
	}
	
	// MARK: - Actions
	
	@objc func orientationDidChange() {
		collectionView.collectionViewLayout.invalidateLayout()
	}
	
	@objc func sendButtonTapped(_ sender: UIButton) {
		// Check if the message is not empty
		guard !messageBarView.isMessageEmpty else { print("Message empty"); return }
		guard let currentUser = currentUser else { return }
		
		if let messageText = messageBarView.textView.text {
			var message = Message(messageID: nil, senderID: currentUser.userID, senderType: currentUser.type ?? 2, receiverID: 1, receiverType: 0, date: Date(), content: messageText)
			messages.append(message)
			
			// Send through socket
			if let data = try? encoder.encode(message) {
				socket?.write(data: data)
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
		scrollToBottom()
	}
	
	@objc func keyboardWillShow(notification: NSNotification) {
		guard let userInfo = notification.userInfo else { return }
		guard let animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double else { return }
		guard let keyboardEndFrame = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue else { return }
		
		var keyboardHeight = keyboardEndFrame.cgRectValue.height
		
		if #available(iOS 11.0, *) {
			keyboardHeight -= view.safeAreaInsets.bottom
		}
		
		messageBarViewBottomConstraint.constant = -keyboardHeight
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
		
		UIView.animate(withDuration: animationDuration) { [unowned self] in
			self.view.layoutIfNeeded()
		}
	}
}

// MARK: - UICollectionViewDataSource
extension ConversationController: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return messages.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MessageCell", for: indexPath) as? MessageCell else {
			return UICollectionViewCell()
		}
		
		guard let currentUser = currentUser else { return cell }
		
		let message = messages[indexPath.item]
		
		cell.messageLabel.text = message.content
		
		if message.senderID != currentUser.userID {
			cell.messageLabel.textColor = .receivedBubbleText
			cell.contentView.backgroundColor = .receivedBubbleBackground
		} else {
			cell.messageLabel.textColor = .sentBubbleText
			cell.contentView.backgroundColor = .sentBubbleBackground
		}
		
		return cell
	}
}

// MARK: - ConversationLayoutDelegate
extension ConversationController: ConversationLayoutDelegate {
	func collectionView(_ collectionView: UICollectionView, isMessageFromUserFor indexPath: IndexPath) -> Bool {
		guard let currentUser = currentUser else { return false }
		
		let message = messages[indexPath.item]
		return message.senderID == currentUser.userID
	}
	
	func collectionView(_ collectionView: UICollectionView, textAt indexPath: IndexPath) -> String {
		return messages[indexPath.item].content
	}
	
	func collectionView(_ collectionView: UICollectionView, fontAt indexPath: IndexPath) -> UIFont {
		return UIFont.systemFont(ofSize: 17)
	}
}

// MARK: - WebSocketDelegate
extension ConversationController: WebSocketDelegate {
	func websocketDidConnect(socket: WebSocketClient) {
		print(#function)
	}
	
	func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
		print(#function, error ?? "")
	}
	
	func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
		guard let json = text.data(using: .utf8) else { return }
		guard let message = try? decoder.decode(Message.self, from: json) else { return }
		guard message.messageID != nil else { return }
		
		messages.append(message)
		Database().createOrUpdate(model: message, with: MessageObject.init)
		
		DispatchQueue.main.async { [weak self] in
			self?.collectionView.reloadData()
			self?.scrollToBottom()
		}
	}
	
	func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
		
	}
}
