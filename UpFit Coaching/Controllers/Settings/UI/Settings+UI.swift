//
//  Settings+UI.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 04/05/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
// Version 1.0

import UIKit
import Eureka

extension SettingsController {
	fileprivate func setUIComponents() {		
		editProfileRow = ButtonRow("editProfile") {
			$0.title = "editProfileButton".localized
			$0.cellUpdate { cell, _ in
				cell.textLabel?.textColor = .mainText
				cell.textLabel?.textAlignment = .left
				cell.accessoryType = .disclosureIndicator
			}
			$0.onCellSelection { [unowned self] _, _ in
				self.editProfile()
			}
		}
		
		let database = Database()
		guard let currentUser = database.getCurrentUser() else { return }
		
		if database.getLastPrescription(for: currentUser) != nil {
			prescriptionRow = ButtonRow("prescription") {
				$0.title = "displayPrescription".localized
				$0.cellUpdate { cell, _ in
					cell.textLabel?.textColor = .mainText
					cell.textLabel?.textAlignment = .left
					cell.accessoryType = .disclosureIndicator
				}
				$0.onCellSelection { [unowned self] _, _ in
					self.prescription()
				}
			}
		}
		
		if currentUser.type == 0 || currentUser.type == 1 {
			coachRow = ButtonRow("coachProfile") {
				$0.title = "coachController_title".localized
				$0.cellUpdate { cell, _ in
					cell.textLabel?.textColor = .mainText
					cell.textLabel?.textAlignment = .left
					cell.accessoryType = .disclosureIndicator
				}
				$0.onCellSelection { [unowned self] _, _ in
					self.coach()
				}
			}
		}
		
		usedLibrariesRow = ButtonRow("usedLibraries") {
			$0.title = "librariesController_title".localized
			$0.cellUpdate { cell, _ in
				cell.textLabel?.textColor = .mainText
				cell.textLabel?.textAlignment = .left
				cell.accessoryType = .disclosureIndicator
			}
			$0.onCellSelection { [unowned self] _, _ in
				self.usedLibraries()
			}
		}
		
		signOutRow = ButtonRow("signOut") {
			$0.title = "signOutButton".localized
			$0.cellUpdate { cell, _ in
				cell.textLabel?.textColor = .destructive
				
			}
			$0.onCellSelection { [unowned self] _, _ in
				self.signOutTapped()
			}
		}
	}
	
	func setupLayout() {
		setUIComponents()
		
		let firstSection = Section("accountManagement_sectionTitle".localized) <<< editProfileRow
		if let prescriptionRow = prescriptionRow {
			firstSection <<< prescriptionRow
		}
		
		let secondSection = Section()
		if let coachRow = coachRow {
			secondSection <<< coachRow
		}
		
		form +++ firstSection
		form +++ secondSection <<< usedLibrariesRow
		form +++ Section() <<< signOutRow
	}
}
