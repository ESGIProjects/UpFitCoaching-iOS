//
//  MessageBarView.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 18/02/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit

class MessageBarView: UIView {
	
	var textView: UITextView!
	var button: UIButton!
	var placeholder: String? {
		didSet {
			if textView.text == "" {
				textView.text = placeholder
				textView.textColor = .lightGray
			}
		}
	}
	
	private var isEditing = false
	private var target: UIViewController?
	private var action: Selector?
	
	var isMessageEmpty: Bool {
		return textView.text == "" || textView.text == placeholder && !isEditing
	}
	
	func addTarget(_ target: UIViewController?, action: Selector) {
		self.target = target
		self.action = action
	}
	
	@objc private func buttonTapped() {
		if let action = action {
			target?.performSelector(onMainThread: action, with: nil, waitUntilDone: false)
		}
		
		textFieldHeightConstraint.constant = 35.0
		textView.isScrollEnabled = false
	}
	
	private var textFieldHeightConstraint: NSLayoutConstraint!
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupLayout()
	}
	
	convenience init() {
		self.init(frame: .zero)
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		if let textView = aDecoder.decodeObject(forKey: "textView") as? UITextView {
			self.textView = textView
		}
		
		if let button = aDecoder.decodeObject(forKey: "button") as? UIButton {
			self.button = button
		}
		
		placeholder = aDecoder.decodeObject(forKey: "placeholder") as? String
	}
	
	override func encode(with aCoder: NSCoder) {
		super.encode(with: aCoder)
		
		aCoder.encode(textView, forKey: "textView")
		aCoder.encode(button, forKey: "button")
		aCoder.encode(placeholder, forKey: "placeholder")
	}
	
	private func getConstraints() -> [NSLayoutConstraint] {
		return [
			textView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8.0),
			textView.topAnchor.constraint(equalTo: topAnchor, constant: 8.0),
			textView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8.0),
			textView.trailingAnchor.constraint(equalTo: button.leadingAnchor, constant: -8.0),
			
			button.heightAnchor.constraint(equalToConstant: 36.0),
			button.widthAnchor.constraint(equalToConstant: 36.0),
			button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8.0),
			button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8.0)
		]
	}
	
	private func setUIComponents() {
		// Initialize Text View
		textView = UITextView()
		textView.delegate = self
		textView.translatesAutoresizingMaskIntoConstraints = false
		textView.font = UIFont.systemFont(ofSize: 16)
		textView.isScrollEnabled = false
		
		// Customize Text View
		textView.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
		textView.layer.borderWidth = 1.0
		textView.layer.cornerRadius = 15.0
		textView.layer.masksToBounds = true
		
		// Initialize Button
		button = UIButton()
		button.translatesAutoresizingMaskIntoConstraints = false
		button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
		button.setImage(#imageLiteral(resourceName: "send"), for: .normal)
		button.tintColor = UIColor(red: 17.0/255.0, green: 142.0/255.0, blue: 135.0/255.0, alpha: 1.0)
	}
	
	private func setupLayout() {
		setUIComponents()
		
		// Add a blur effect
		let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
		blurEffectView.frame = bounds
		
		blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		addSubview(blurEffectView)
		
		// Add elements to the view
		addSubview(textView)
		addSubview(button)
		
		// Add constraints
		textFieldHeightConstraint = textView.heightAnchor.constraint(equalToConstant: 35.0)
		textFieldHeightConstraint.isActive = true
		
		NSLayoutConstraint.activate(getConstraints())
	}
}

extension MessageBarView: UITextViewDelegate {
	func textViewDidBeginEditing(_ textView: UITextView) {
		isEditing = true
		
		if textView.text == placeholder {
			textView.text = ""
			textView.textColor = .black
		}
	}

	func textViewDidEndEditing(_ textView: UITextView) {
		isEditing = false
		
		if textView.text == "" || textView.text == placeholder {
			textView.text = placeholder
			textView.textColor = .lightGray
		}
	}
	
	func textViewDidChange(_ textView: UITextView) {
		let maxHeight = UIScreen.main.bounds.height / 3
		
		let size = textView.sizeThatFits(CGSize(width: textView.frame.size.width, height: maxHeight))
		textFieldHeightConstraint.constant = CGFloat.minimum(size.height, maxHeight)
		
		textView.isScrollEnabled = textView.contentSize.height >= maxHeight
	}
}
