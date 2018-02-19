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
	
	lazy var messageBarView: MessageBarView = {
		let messageBarView = MessageBarView()
		messageBarView.translatesAutoresizingMaskIntoConstraints = false
		messageBarView.backgroundColor = UIColor.gray.withAlphaComponent(0.3)
		
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
		setupLayout()
		
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: .UIKeyboardWillHide, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: .UIKeyboardWillChangeFrame, object: nil)
	}
	
	// MARK: - Layout helpers
	
	func setupLayout() {
		
		// Scroll view
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
				scrollView.leftAnchor.constraint(equalTo: view.leadingAnchor),
				scrollView.rightAnchor.constraint(equalTo: view.trailingAnchor)
				])
		}
		
		// Text Field
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
		
		// Updates size properties
		messageBarView.setNeedsLayout()
		messageBarView.layoutIfNeeded()
		
		scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: messageBarView.frame.height, right: 0)
		
		// Fake test messages
		
		var lastLabel: UILabel?
		
		for index in 0 ..< 50 {
			let label = UILabel()
			label.translatesAutoresizingMaskIntoConstraints = false
			label.text = "This is my label number \(index)"
			scrollView.addSubview(label)
			label.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: label.intrinsicContentSize.height * CGFloat(index)).isActive = true
			label.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 8.0).isActive = true
			
			scrollView.contentSize.height += label.intrinsicContentSize.height
			lastLabel = label
		}
		
		if let label = lastLabel {
			label.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0).isActive = true
			
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
		// debug : add a label
		
	}
}
