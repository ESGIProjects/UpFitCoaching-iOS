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
		scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 44, right: 0)
		return scrollView
	}()
	
	lazy var textField: UITextField = {
		let textField = UITextField()
		textField.translatesAutoresizingMaskIntoConstraints = false
		textField.backgroundColor = UIColor.red.withAlphaComponent(0.5)
		textField.placeholder = "Message"
		return textField
	}()
	
	lazy var textFieldView: UIView = {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.backgroundColor = UIColor.gray.withAlphaComponent(0.3)
		return view
	}()
	
	lazy var textFieldButton: UIButton = {
		let button = UIButton()
		button.translatesAutoresizingMaskIntoConstraints = false
		button.setTitle("Send", for: .normal)
		button.addTarget(self, action: #selector(sendButtonTapped(_:)), for: .touchUpInside)
		return button
	}()
	
	var textFieldBottomConstraint: NSLayoutConstraint!
	var textFieldHeightConstraint: NSLayoutConstraint!
	
	// MARK: - UIViewController
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupLayout()
		
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: .UIKeyboardWillHide, object: nil)
	}
	
	// MARK: - Layout helpers
	
	fileprivate func setupTextFieldView() {
		
		// Adding subviews
		
		textFieldView.addSubview(textField)
		textFieldView.addSubview(textFieldButton)
		
		// Text Field Height Constraint
		
		textFieldHeightConstraint = textField.heightAnchor.constraint(equalToConstant: 44)
		textFieldHeightConstraint.isActive = true
		
		// Subviews Constraints
		
		NSLayoutConstraint.activate([
			textField.leadingAnchor.constraint(equalTo: textFieldView.leadingAnchor, constant: 8),
			textField.topAnchor.constraint(equalTo: textFieldView.topAnchor, constant: 8),
			textField.bottomAnchor.constraint(equalTo: textFieldView.bottomAnchor, constant: -8),
			textFieldButton.heightAnchor.constraint(equalToConstant: 44),
			textFieldButton.widthAnchor.constraint(equalToConstant: 50),
			textFieldButton.bottomAnchor.constraint(equalTo: textFieldView.bottomAnchor, constant: -8),
			textFieldButton.trailingAnchor.constraint(equalTo: textFieldView.trailingAnchor, constant: -8),
			textField.trailingAnchor.constraint(equalTo: textFieldButton.leadingAnchor, constant: -8),
			])
		
		// Adding view
		view.addSubview(textFieldView)
		
		// View constraints
		
		if #available(iOS 11.0, *) {
			textFieldBottomConstraint = textFieldView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)

			NSLayoutConstraint.activate([
				textFieldBottomConstraint,
				textFieldView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
				textFieldView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
				])
		} else {
			textFieldBottomConstraint = textFieldView.bottomAnchor.constraint(equalTo: view.bottomAnchor)

			NSLayoutConstraint.activate([
				textFieldBottomConstraint,
				textFieldView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
				textFieldView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
				])
		}
	}
	
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

		setupTextFieldView()
		
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
		print("Keyboard will show")
		guard let userInfo = notification.userInfo else { return }
		guard let animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double else { return }
		guard let keyboardEndFrame = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue else { return }
		
		textFieldBottomConstraint.constant = -keyboardEndFrame.cgRectValue.height
		scrollView.contentInset.bottom += keyboardEndFrame.cgRectValue.height
		
		UIView.animate(withDuration: animationDuration) { [unowned self] in
			self.view.layoutIfNeeded()
		}
	}
	
	@objc func keyboardWillHide(notification: NSNotification) {
		print("Keyboard will hide")
		guard let userInfo = notification.userInfo else { return }
		guard let animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double else { return }
		
		textFieldBottomConstraint.constant = 0.0
		scrollView.contentInset.bottom = textField.frame.height
		
		UIView.animate(withDuration: animationDuration) { [unowned self] in
			self.view.layoutIfNeeded()
		}
	}
	
	@objc func sendButtonTapped(_ sender: UIButton) {
		print("Send tapped")
	}
}

