//
//  MessageBarView.swift
//  Coaching
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
	
	var isMessageEmpty: Bool {
		return textView.text == "" || textView.text == placeholder
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
		
		textView = aDecoder.decodeObject(forKey: "textView") as! UITextView
		button = aDecoder.decodeObject(forKey: "button") as! UIButton
		placeholder = aDecoder.decodeObject(forKey: "placeholder") as? String
	}
	
	override func encode(with aCoder: NSCoder) {
		aCoder.encode(textView, forKey: "textView")
		aCoder.encode(button, forKey: "button")
		aCoder.encode(placeholder, forKey: "placeholder")
		
		super.encode(with: aCoder)
	}
	
	private func setupLayout() {
		// Initializing Text View
		textView = UITextView()
		textView.delegate = self
		textView.translatesAutoresizingMaskIntoConstraints = false
		textView.font = UIFont.systemFont(ofSize: 16)
		textView.isScrollEnabled = false
		
		// Initializing Button
		button = UIButton()
		button.translatesAutoresizingMaskIntoConstraints = false
		
		// Adds elements to view
		addSubview(textView)
		addSubview(button)
		
		// Constraints
		textFieldHeightConstraint = textView.heightAnchor.constraint(equalToConstant: 35)
		textFieldHeightConstraint.isActive = true
		
		NSLayoutConstraint.activate([
			textView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
			textView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
			textView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
			button.heightAnchor.constraint(equalToConstant: 35),
			button.widthAnchor.constraint(equalToConstant: 50),
			button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
			button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
			textView.trailingAnchor.constraint(equalTo: button.leadingAnchor, constant: -8),
			])
	}
}

extension MessageBarView: UITextViewDelegate {
	func textViewDidBeginEditing(_ textView: UITextView) {
		guard let placeholder = placeholder else { return }
		
		if textView.text == placeholder {
			textView.text = ""
			textView.textColor = .black
		}
	}

	func textViewDidEndEditing(_ textView: UITextView) {
		guard let placeholder = placeholder else { return }
		
		if textView.text == "" {
			textView.text = placeholder
			textView.textColor = .lightGray
		}
	}
	
	func textViewDidChange(_ textView: UITextView) {
		let maxHeight = UIScreen.main.bounds.height/3
		
		let size = textView.sizeThatFits(CGSize(width: textView.frame.size.width, height: maxHeight))
		textFieldHeightConstraint.constant = CGFloat.minimum(size.height, maxHeight)
	}
}
