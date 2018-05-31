//
//  AddEvent+UI.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 04/05/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit
import Eureka

extension AddEventController {
	fileprivate func setUIComponents() {
		titleRow = TextRow("title") {
			$0.placeholder = "eventTitle_placeholder".localized
			$0.value = eventTitle
			$0.onChange { [unowned self] row in
				if let value = row.value {
					self.eventTitle = value
					self.toggleConfirmationButton()
				}
			}
		}
		
		if currentUser?.type == 2 {
			otherUserRow = PushRow<User>("otherUser") {
				$0.title = "otherUser_fieldTitle".localized
				$0.value = otherUser
				
				var users = Database().fetch(using: User.all)
				
				guard let currentUser = currentUser,
					let index = users.index(of: currentUser) else { return }
				
				users.remove(at: index)
				
				$0.options = users
				$0.displayValueFor = { value in
					guard let value = value else { return "" }
					return "\(value.firstName) \(value.lastName)"
				}
				$0.onChange { [unowned self] row in
					self.otherUser = row.value
				}
			}
		}
		
		startDateRow = DateTimeInlineRow("startDate") {
			$0.title = "startDate_fieldTitle".localized
			$0.value = startDate
			$0.onChange { [unowned self] row in
				if let value = row.value {
					self.startDate = value
					self.validateDates()
					self.toggleConfirmationButton()
				}
			}
		}
		
		endDateRow = DateTimeInlineRow("endDate") {
			$0.title = "endDate_fieldTitle".localized
			$0.value = endDate
			$0.onChange { [unowned self] row in
				if let value = row.value {
					self.endDate = value
					self.validateDates()
					self.toggleConfirmationButton()
				}
			}
		}
	}
	
	func setupLayout() {
		setUIComponents()
		
		let section = Section()
		section <<< titleRow
		
		if let otherUserRow = otherUserRow {
			section <<< otherUserRow
		}
		
		form += [
			section,
			Section() <<< startDateRow <<< endDateRow
		]
	}
}
