//
//  Conversation+UI.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 10/03/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
// Version 1.0

import UIKit

extension ConversationController {
	fileprivate func getConstraints() -> [NSLayoutConstraint] {
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
	
	fileprivate func setUIComponents() {
		let conversationLayout = ConversationLayout()
		conversationLayout.delegate = self
		
		collectionView = UICollectionView(frame: .zero, collectionViewLayout: conversationLayout)
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		collectionView.backgroundColor = .white
		collectionView.keyboardDismissMode = .onDrag
		collectionView.alwaysBounceVertical = true
		collectionView.dataSource = self
		
		messageBarView = UI.messageBar
		messageBarView.addTarget(self, action: #selector(sendButtonTapped(_:)))
	}
	
	func setupLayout() {
		setUIComponents()
		
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
