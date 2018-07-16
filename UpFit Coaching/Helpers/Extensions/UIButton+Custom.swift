//
//  UIButton+Custom.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 23/06/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
// Version 1.0

import UIKit

extension UIButton {
	var titleText: String? {
		get {
			return titleLabel?.text
		}
		set {
			setTitle(newValue, for: .normal)
		}
	}
	
	var titleColor: UIColor? {
		get {
			return titleLabel?.textColor
		}
		set {
			setTitleColor(newValue, for: .normal)
		}
	}
	
	var titleFont: UIFont? {
		get {
			return titleLabel?.font
		}
		set {
			titleLabel?.font = newValue
		}
	}
}
