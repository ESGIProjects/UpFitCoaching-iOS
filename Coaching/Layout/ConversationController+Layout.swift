//
//  ConversationController+Layout.swift
//  Coaching
//
//  Created by Jason Pierna on 10/03/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit

extension ConversationController {
	
	// MARK: - Creating elements
	
	func createCollectionView() -> UICollectionView {
		let collectionViewLayout = ConversationLayout()
		collectionViewLayout.delegate = self
		
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		collectionView.backgroundColor = .white
		collectionView.delegate = self
		collectionView.dataSource = self
		collectionView.keyboardDismissMode = .onDrag
		return collectionView
	}
	
	func createMessageBarView() -> MessageBarView {
		let messageBarView = MessageBarView()
		messageBarView.translatesAutoresizingMaskIntoConstraints = false
		
		messageBarView.placeholder = "message_placeholder".localized
		
		messageBarView.button.setTitle("sendMessage_button".localized, for: .normal)
		messageBarView.button.setTitleColor(.main, for: .normal)
		messageBarView.button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17.0)
		messageBarView.button.addTarget(self, action: #selector(sendButtonTapped(_:)), for: .touchUpInside)
		return messageBarView
	}
	
	// MARK: - Constraints
	
	func layoutConstraints() -> [NSLayoutConstraint] {
		var constraints = [NSLayoutConstraint]()
		
		if #available(iOS 11.0, *) {
			constraints += [
				// Collection view
				collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
				collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
				collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
				collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
				// Message bar view
				messageBarView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
				messageBarView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
			]
		} else {
			constraints += [
				// Collection view
				collectionView.topAnchor.constraint(equalTo: view.topAnchor),
				collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
				collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
				collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
				// Message bar view
				messageBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
				messageBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
			]
		}

		return constraints
	}
}
