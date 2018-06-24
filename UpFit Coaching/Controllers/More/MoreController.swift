//
//  MoreController.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 10/04/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit
import Firebase
import Eureka

class MoreController: FormViewController {
	
	var editProfileRow: ButtonRow!
	var usedLibrariesRow: ButtonRow!
	var signOutRow: ButtonRow!
	
	// MARK: - UIViewController
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = "moreController_title".localized
		setupLayout()
	}
	
	// MARK: - Actions
	
	func editProfile() {
		present(UINavigationController(rootViewController: EditProfileController()), animated: true)
	}
	
	func usedLibraries() {
		navigationController?.pushViewController(LibrariesController(), animated: true)
	}
	
	func signOut() {
		// Clear database
		Database().deleteAll()
		
		// Clear preferences
		UserDefaults.standard.removeObject(forKey: "userID")
		UserDefaults.standard.removeObject(forKey: "firebaseToken")
		
		// Disconnect from webscoket
		MessagesDelegate.instance.disconnect()
		
		// Reset Firebase ID
		InstanceID.instanceID().deleteID { error in
			if let error = error {
				print(error.localizedDescription)
			}
		}
		
		// Go back to thee login screen
		if tabBarController?.presentingViewController != nil {
			tabBarController?.dismiss(animated: true)
		} else {
			guard let window = (UIApplication.shared.delegate as? AppDelegate)?.window else { return }
			window.rootViewController = UINavigationController(rootViewController: LoginController())
		}
	}
}
