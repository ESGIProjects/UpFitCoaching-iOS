//
//  ConversationController.swift
//  Coaching
//
//  Created by Jason Pierna on 13/02/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit

class ConversationController: UIViewController {

	static let currentUser = "Silver"
	
	lazy var collectionView = UI.collectionView(delegate: self, dataSource: self, layoutDelegate: self)
	lazy var messageBarView = UI.messageBarView(self, action: #selector(sendButtonTapped(_:)))
	
	private var messageBarViewBottomConstraint: NSLayoutConstraint!
	
	var messages = [Message](repeating: Message("debug_shortMessage".localized, from: "Kévin Le", to: "Jason Pierna", at: Date()), count: 20)
	
	// MARK: - UIViewController
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = .white
		edgesForExtendedLayout = []
		collectionView.register(MessageCell.self, forCellWithReuseIdentifier: "MessageCell")
		
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
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
		NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
		NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillChangeFrame, object: nil)
		NotificationCenter.default.removeObserver(self, name: .UIDeviceOrientationDidChange, object: nil)
	}
	
	@objc func orientationDidChange() {
		collectionView.collectionViewLayout.invalidateLayout()
	}
	
	// MARK: - Layout helpers
	
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
	
	@objc func sendButtonTapped(_ sender: UIButton) {
		// Check if the message is not empty
		guard !messageBarView.isMessageEmpty else { print("Message empty"); return }
		
		if let messageContent = messageBarView.textView.text {
			messages.append(Message(messageContent, from: ConversationController.currentUser, to: "Kévin Le", at: Date()))
		}
		
		// Empty the text view
		messageBarView.textView.text = ""
		
		// Reload UI
		collectionView.reloadData()

		// Scroll to bottom
		collectionView.setNeedsLayout()
		collectionView.layoutIfNeeded()
		
		collectionView.scrollRectToVisible(CGRect(x: 0, y: collectionView.contentSize.height - 1, width: collectionView.contentSize.width, height: 1), animated: true)
	}
	
	@objc func keyboardWillShow(notification: NSNotification) {
		guard let userInfo = notification.userInfo else { return }
		guard let animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double else { return }
		guard let keyboardEndFrame = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue else { return }
		
		messageBarViewBottomConstraint.constant = -keyboardEndFrame.cgRectValue.height
		collectionView.contentInset.bottom = messageBarView.frame.height + keyboardEndFrame.cgRectValue.height
		collectionView.scrollRectToVisible(CGRect(x: 0, y: collectionView.contentSize.height - 1, width: collectionView.contentSize.width, height: 1), animated: true)
		
		UIView.animate(withDuration: animationDuration) { [unowned self] in
			self.view.layoutIfNeeded()
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

// MARK: - UICollectionViewDelegate
extension ConversationController: UICollectionViewDelegate {
	
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
		
		let message = messages[indexPath.item]
		
		cell.messageLabel.text = message.content
		
		if message.sender != ConversationController.currentUser {
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
	func collectionView(_ collectionView: UICollectionView, messageSideFor indexPath: IndexPath) -> Side {
		let message = messages[indexPath.item]
		return message.sender == ConversationController.currentUser ? .right : .left
	}
	
	func collectionView(_ collectionView: UICollectionView, textAt indexPath: IndexPath) -> String {
		return messages[indexPath.item].content
	}
	
	func collectionView(_ collectionView: UICollectionView, fontAt indexPath: IndexPath) -> UIFont {
		return UIFont.systemFont(ofSize: 17)
	}
}
