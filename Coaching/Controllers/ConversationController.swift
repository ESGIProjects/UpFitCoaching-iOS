//
//  ConversationController.swift
//  Coaching
//
//  Created by Jason Pierna on 13/02/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit

class ConversationController: UIViewController {

	lazy var collectionView = createCollectionView()
	lazy var messageBarView = createMessageBarView()
	
	private var messageBarViewBottomConstraint: NSLayoutConstraint!
	
	var messages = [(message: String, side: Side)](repeating: (message: "debug_shortMessage".localized, side: .left), count: 20)
	
	// MARK: - UIViewController
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = .white
		
		edgesForExtendedLayout = []
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(test))
		collectionView.register(MessageCell.self, forCellWithReuseIdentifier: "MessageCell")
		
		setupLayout()
		
//		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
//		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: .UIKeyboardWillHide, object: nil)
//		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: .UIKeyboardWillChangeFrame, object: nil)
	}
	
	@objc func test() {
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
		
		NSLayoutConstraint.activate(layoutConstraints())
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
		
		if let message = messageBarView.textView.text {
			messages.append((message: message, side: .right))
		}
		
		// Empty the text view
		messageBarView.textView.text = ""
		
		// Reload UI
		collectionView.reloadData()
	}
	
	/*
	
	@objc func keyboardWillHide(notification: NSNotification) {
		guard let userInfo = notification.userInfo else { return }
		guard let animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double else { return }
		
		messageBarViewBottomConstraint.constant = 0.0
		scrollView.contentInset.bottom = messageBarView.frame.height
		
		UIView.animate(withDuration: animationDuration) { [unowned self] in
			self.view.layoutIfNeeded()
		}
	}
	
	@objc func sendButtonTapped(_ sender: UIButton) {
		// Scroll to make the new message visible
		contentView.setNeedsLayout()
		contentView.layoutIfNeeded()
		
		scrollView.scrollRectToVisible(message.frame, animated: true)
	}*/
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
		
		cell.messageLabel.text = message.message
		cell.messageLabel.textColor = message.side == .left ? MessageCell.leftTextColor : MessageCell.rightTextColor
		cell.contentView.backgroundColor = message.side == .left ? MessageCell.leftColor : MessageCell.rightColor
		
		return cell
	}
}

// MARK: - ConversationLayoutDelegate
extension ConversationController: ConversationLayoutDelegate {
	func collectionView(_ collectionView: UICollectionView, messageSideFor indexPath: IndexPath) -> Side {
		return messages[indexPath.item].side
	}
	
	func collectionView(_ collectionView: UICollectionView, textAt indexPath: IndexPath) -> (String, UIFont) {
		return (messages[indexPath.item].message, UIFont.systemFont(ofSize: 17))
	}
}
