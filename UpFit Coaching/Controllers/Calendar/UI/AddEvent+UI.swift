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
					self.toggleAddButton()
				}
			}
		}
		
		if currentUser?.type == 2 {
			otherUserRow = PushRow<String>("otherUser") {
				$0.title = "Other user"
				$0.options = ["Jason Pierna", "Kévin Le", "Maëva Malih"]
			}
		}
		
		startDateRow = DateTimeInlineRow("startDate") {
			$0.title = "startDate_fieldTitle".localized
			$0.value = startDate
			$0.onChange { [unowned self] row in
				if let value = row.value {
					self.startDate = value
					self.validateDates()
					self.toggleAddButton()
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
					self.toggleAddButton()
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
