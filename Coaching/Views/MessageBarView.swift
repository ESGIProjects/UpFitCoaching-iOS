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
	
	private func setupLayout() {
		// Add a blur effect
		let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
		blurEffectView.frame = bounds
		
		blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		addSubview(blurEffectView)
		
		// Initialize Text View
		textView = UITextView()
		textView.delegate = self
		textView.translatesAutoresizingMaskIntoConstraints = false
		textView.font = UIFont.systemFont(ofSize: 16)
		textView.isScrollEnabled = false
		
		// Initialize Button
		button = UIButton()
		button.translatesAutoresizingMaskIntoConstraints = false
		
		// Add elements to the view
		addSubview(textView)
		addSubview(button)
		
		// Customize Text View
		textView.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
		textView.layer.borderWidth = 1.0
		textView.layer.cornerRadius = 15.0
		textView.layer.masksToBounds = true
		
		// Add constraints
		textFieldHeightConstraint = textView.heightAnchor.constraint(equalToConstant: 35)
		textFieldHeightConstraint.isActive = true
		
		NSLayoutConstraint.activate([
			textView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
			textView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
			textView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
			textView.trailingAnchor.constraint(equalTo: button.leadingAnchor, constant: -8),
			button.heightAnchor.constraint(equalToConstant: 35),
			button.widthAnchor.constraint(equalToConstant: 65),
			button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
			button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
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
