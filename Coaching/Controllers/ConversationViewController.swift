//
//  ViewController.swift
//  Coaching
//
//  Created by Jason Pierna on 13/02/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit

class ConversationViewController: UIViewController {
	
	lazy var scrollView: UIScrollView = {
		let scrollView = UIScrollView()
		scrollView.translatesAutoresizingMaskIntoConstraints = false
		scrollView.keyboardDismissMode = .onDrag
		return scrollView
	}()
	
	lazy var contentView: UIView = {
		let contentView = UIView()
		contentView.translatesAutoresizingMaskIntoConstraints = false
		return contentView
	}()
	
	lazy var messageBarView: MessageBarView = {
		let messageBarView = MessageBarView()
		messageBarView.translatesAutoresizingMaskIntoConstraints = false
		
		messageBarView.placeholder = "Message"
		
		messageBarView.button.setTitle("Send", for: .normal)
		messageBarView.button.setTitleColor(.blue, for: .normal)
		messageBarView.button.addTarget(self, action: #selector(sendButtonTapped(_:)), for: .touchUpInside)
		return messageBarView
	}()
	
	private var messageBarViewBottomConstraint: NSLayoutConstraint!
	
	// MARK: - UIViewController
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		edgesForExtendedLayout = []
		setupLayout()
		
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: .UIKeyboardWillHide, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: .UIKeyboardWillChangeFrame, object: nil)
	}
	
	// MARK: - Layout helpers
	
	func setupLayout() {
		
		// Layout the Scroll view
		view.addSubview(scrollView)
		
		if #available(iOS 11.0, *) {
			NSLayoutConstraint.activate([
				scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
				scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
				scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
				scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
				])
		} else {
			NSLayoutConstraint.activate([
				scrollView.topAnchor.constraint(equalTo: view.topAnchor),
				scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
				scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
				scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
				])
		}
		
		// Layout the Content view
		scrollView.addSubview(contentView)
		
		NSLayoutConstraint.activate([
			contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
			contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
			contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
			contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
			contentView.widthAnchor.constraint(equalTo: view.widthAnchor),
			])
		
		// Layout the Message Bar
		view.addSubview(messageBarView)
		
		if #available(iOS 11.0, *) {
			messageBarViewBottomConstraint = messageBarView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
			
			NSLayoutConstraint.activate([
				messageBarViewBottomConstraint,
				messageBarView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
				messageBarView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
				])
		} else {
			messageBarViewBottomConstraint = messageBarView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
			
			NSLayoutConstraint.activate([
				messageBarViewBottomConstraint,
				messageBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
				messageBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
				])
		}
		
		// Update scroll view insets
		messageBarView.setNeedsLayout()
		messageBarView.layoutIfNeeded()
		
		scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: messageBarView.frame.height, right: 0)
		scrollView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: messageBarView.frame.height, right: 0)
		
		// Add fake messages
		
		var lastMessage: UILabel?

		for index in 0 ..< 50 {
			let message = UILabel()
			message.translatesAutoresizingMaskIntoConstraints = false
			message.text = "This is my label number \(index)"
			message.numberOfLines = 0

			contentView.addSubview(message)

			if lastMessage != nil {
				message.topAnchor.constraint(equalTo: lastMessage!.bottomAnchor, constant: 0).isActive = true
			} else {
				message.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
			}

			message.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8.0).isActive = true
			message.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8.0).isActive = true

			lastMessage = message
		}

		if let lastMessage = lastMessage {
			lastMessage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
			
			scrollView.setNeedsLayout()
			scrollView.layoutIfNeeded()
			
			let bottomOffset = CGPoint(x: 0, y: scrollView.contentSize.height)
			scrollView.setContentOffset(bottomOffset, animated: true)
		}
	}
	
	@objc func keyboardWillShow(notification: NSNotification) {
		guard let userInfo = notification.userInfo else { return }
		guard let animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double else { return }
		guard let keyboardEndFrame = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue else { return }
		
		messageBarViewBottomConstraint.constant = -keyboardEndFrame.cgRectValue.height
		scrollView.contentInset.bottom = messageBarView.frame.height + keyboardEndFrame.cgRectValue.height
		scrollView.scrollRectToVisible(CGRect(x: 0, y: scrollView.contentSize.height - 1, width: scrollView.contentSize.width, height: 1), animated: true)
		
		UIView.animate(withDuration: animationDuration) { [unowned self] in
			self.view.layoutIfNeeded()
		}
	}
	
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
		
		// Check if the message is not empty
		guard !messageBarView.isMessageEmpty else { print("Message empty"); return }
		
		// Create the new message
		let message = UILabel()
		message.text = messageBarView.textView.text
		message.translatesAutoresizingMaskIntoConstraints = false
		
		// Empty the text view
		messageBarView.textView.text = ""
		
		var topConstraint: NSLayoutConstraint!
		
		// Delete constraint on last message if exist
		if let bottomConstraint = contentView.constraints.filter({ constraint -> Bool in
			return constraint.firstAttribute == .bottom && constraint.secondItem === self.contentView
		}).first {
			guard let lastMessage = bottomConstraint.firstItem as? UILabel else { return }
			
			contentView.removeConstraint(bottomConstraint)
			
			topConstraint = message.topAnchor.constraint(equalTo: lastMessage.bottomAnchor)
		} else {
			topConstraint = message.topAnchor.constraint(equalTo: contentView.topAnchor)
		}
		

		// Add the new message at the end
		contentView.addSubview(message)

		NSLayoutConstraint.activate([
			topConstraint,
			message.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
			message.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8.0),
			message.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8.0)
			])
		
		// Scroll to make the new message visible
		contentView.setNeedsLayout()
		contentView.layoutIfNeeded()
		
		scrollView.scrollRectToVisible(message.frame, animated: true)
	}
}
