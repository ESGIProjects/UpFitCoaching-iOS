//
//  Settings+UI.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 04/05/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit
import Eureka

extension SettingsController {	
	fileprivate func setUIComponents() {
		signOutRow = ButtonRow("") {
			$0.title = "signOutButton".localized
			$0.cellUpdate { cell, _ in
				cell.textLabel?.tintColor = .red
				cell.textLabel?.textColor = .red
				
			}
			$0.onCellSelection { [unowned self] _, _ in
				self.signOut()
			}
		}
	}
	
	func setupLayout() {
		setUIComponents()
		
		form +++ Section() <<< signOutRow
	}
}
