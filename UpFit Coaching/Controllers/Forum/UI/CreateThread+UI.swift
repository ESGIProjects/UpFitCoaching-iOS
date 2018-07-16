//
//  CreateThread+UI.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 07/06/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
// Version 1.0

import UIKit
import Eureka

extension CreateThreadController {
	fileprivate func setUIComponents() {
		titleRow = TextRow("title") {
			$0.placeholder = "threadTitle_placeholder".localized
			$0.value = threadTitle
			$0.onChange { [unowned self] row in
				self.threadTitle = row.value ?? ""
				self.toggleAddButton()
				
			}
		}
		
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
		
		form +++ Section() <<< titleRow <<< contentRow
	}
}
