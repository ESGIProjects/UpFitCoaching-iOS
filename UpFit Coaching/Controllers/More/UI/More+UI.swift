//
//  More+UI.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 04/05/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit
import Eureka

extension MoreController {
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
		
		let currentUser = Database().getCurrentUser()
		if currentUser?.type == 0 || currentUser?.type == 1 {
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
				self.signOut()
			}
		}
	}
	
	func setupLayout() {
		setUIComponents()
		
		let section = Section()
		if let coachRow = coachRow {
			section <<< coachRow
		}
		
		form +++ Section("accountManagement_sectionTitle".localized) <<< editProfileRow
		form +++ section <<< usedLibrariesRow
		form +++ Section() <<< signOutRow
	}
}
