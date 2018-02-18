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
		textField.backgroundColor = UIColor.red.withAlphaComponent(0.3)
		return textField
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
	
	func setupLayout() {
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
		
		view.addSubview(textField)
		textFieldHeightConstraint = textField.heightAnchor.constraint(equalToConstant: 44)
		textFieldHeightConstraint.isActive = true
		
		if #available(iOS 11.0, *) {
			textFieldBottomConstraint = textField.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
			
			NSLayoutConstraint.activate([
				textFieldBottomConstraint,
				textField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
				textField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
				])
		} else {
			textFieldBottomConstraint = textField.bottomAnchor.constraint(equalTo: view.bottomAnchor)
			
			NSLayoutConstraint.activate([
				textFieldBottomConstraint,
				textField.leadingAnchor.constraint(equalTo: view.leadingAnchor),
				textField.trailingAnchor.constraint(equalTo: view.trailingAnchor)
				])
		}
		
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
}

