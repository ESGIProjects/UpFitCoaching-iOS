//
//  AddPost+UI.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 11/06/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
// Version 1.0

import UIKit
import Eureka

extension AddPostController {
	fileprivate func setUIComponents() {
		contentRow = TextAreaRow("content") {
			$0.placeholder = "postContent_placeholder".localized
			$0.value = postContent
			$0.onChange { [unowned self] row in
				self.postContent = row.value ?? ""
				self.toggleAddButton()
			}
		}
	}
	
	func setupLayout() {
		setUIComponents()
		
		form +++ Section() <<< contentRow
	}
}
