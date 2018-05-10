//
//  Conversation+UI.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 10/03/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit

extension ConversationController {
	class UI {
		class func collectionView(layout: UICollectionViewLayout) -> UICollectionView {
			let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
			collectionView.translatesAutoresizingMaskIntoConstraints = false
			
			collectionView.backgroundColor = .white
			collectionView.keyboardDismissMode = .onDrag
			collectionView.alwaysBounceVertical = true
			
			return collectionView
		}
		
		class func messageBarView() -> MessageBarView {
			let messageBarView = MessageBarView()
			messageBarView.translatesAutoresizingMaskIntoConstraints = false
			
			messageBarView.placeholder = "message_placeholder".localized
			
			messageBarView.button.setTitle("sendMessage_button".localized, for: .normal)
			messageBarView.button.setTitleColor(.main, for: .normal)
			messageBarView.button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17.0)
			
			return messageBarView
		}
	}
	
	func getConstraints() -> [NSLayoutConstraint] {
		let anchors = getAnchors()
		
		return [
			collectionView.topAnchor.constraint(equalTo: anchors.top),
			collectionView.bottomAnchor.constraint(equalTo: anchors.bottom),
			collectionView.leadingAnchor.constraint(equalTo: anchors.leading),
			collectionView.trailingAnchor.constraint(equalTo: anchors.trailing),

			messageBarView.leadingAnchor.constraint(equalTo: anchors.leading),
			messageBarView.trailingAnchor.constraint(equalTo: anchors.trailing)
		]
	}
	
	func setUIComponents() {
		let conversationLayout = ConversationLayout()
		conversationLayout.delegate = self
		
		collectionView = UI.collectionView(layout: conversationLayout)
		collectionView.dataSource = self
		
		messageBarView = UI.messageBarView()
		messageBarView.button.addTarget(self, action: #selector(sendButtonTapped(_:)), for: .touchUpInside)
	}
	
	func setupLayout() {
		view.addSubview(collectionView)
		view.addSubview(messageBarView)
		
		messageBarViewBottomConstraint = messageBarView.bottomAnchor.constraint(equalTo: getAnchors().bottom)
		
		NSLayoutConstraint.activate(getConstraints())
		messageBarViewBottomConstraint.isActive = true
		
		// Update scroll view insets
		messageBarView.setNeedsLayout()
		messageBarView.layoutIfNeeded()
		
		collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: messageBarView.frame.height, right: 0)
		collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: messageBarView.frame.height, right: 0)
		
		// Scroll to bottom
		scrollToBottom(animated: false)
	}
}
