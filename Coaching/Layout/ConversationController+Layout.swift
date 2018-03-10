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
	
	func createScrollView() -> UIScrollView {
		let scrollView = UIScrollView()
		scrollView.translatesAutoresizingMaskIntoConstraints = false
		scrollView.keyboardDismissMode = .onDrag
		return scrollView
	}
	
	func createContentView() -> UIView {
		let contentView = UIView()
		contentView.translatesAutoresizingMaskIntoConstraints = false
		return contentView
	}
	
	func createMessageBarView() -> MessageBarView {
		let messageBarView = MessageBarView()
		messageBarView.translatesAutoresizingMaskIntoConstraints = false
		
		messageBarView.placeholder = "Message"
		
		messageBarView.button.setTitle("Send", for: .normal)
		messageBarView.button.setTitleColor(.blue, for: .normal)
		messageBarView.button.addTarget(self, action: #selector(sendButtonTapped(_:)), for: .touchUpInside)
		return messageBarView
	}
	
	// MARK: - Constraints
	
	func layoutConstraints() -> [NSLayoutConstraint] {
		var constraints = [NSLayoutConstraint]()
		
		if #available(iOS 11.0, *) {
			constraints += [
				// Scroll view
				scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
				scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
				scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
				scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
				// Message bar view
				messageBarView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
				messageBarView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
				]
		} else {
			constraints += [
				// Scroll view
				scrollView.topAnchor.constraint(equalTo: view.topAnchor),
				scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
				scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
				scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
				// Message bar view
				messageBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
				messageBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
				]
		}
		
		constraints += [
			// Content view
			contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
			contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
			contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
			contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
			contentView.widthAnchor.constraint(equalTo: view.widthAnchor)
		]
		
		return constraints
	}
}
