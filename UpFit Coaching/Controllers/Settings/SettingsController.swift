//
//  SettingsController.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 10/04/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit
import Eureka

class SettingsController: FormViewController {
	
	var signOutRow: ButtonRow!
	
	// MARK: - UIViewController
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = "settingsController_title".localized
		setupLayout()
	}
	
	// MARK: - Actions
	
	func signOut() {
		Database().deleteAll()
		UserDefaults.standard.removeObject(forKey: "userID")
		MessagesDelegate.instance.disconnect()
		
		if tabBarController?.presentingViewController != nil {
			tabBarController?.dismiss(animated: true)
		} else {
			guard let window = (UIApplication.shared.delegate as? AppDelegate)?.window else { return }
			window.rootViewController = UINavigationController(rootViewController: LoginController())
		}
	}
}
