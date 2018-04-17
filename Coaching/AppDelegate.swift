//
//  AppDelegate.swift
//  Coaching
//
//  Created by Jason Pierna on 13/02/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		
		window = UIWindow(frame: UIScreen.main.bounds)
		window?.backgroundColor = .white
		
		let users = Database().fetch(using: User.all)
		
		if let user = users.first {
			// Show the corresponding tab bar controller
			window?.rootViewController = user.type == 0 ? UITabBarController.coachController() : UITabBarController.clientController()
		} else {
			// Show login
			window?.rootViewController = UINavigationController(rootViewController: LoginController())
		}
		
		window?.makeKeyAndVisible()
		
		return true
	}
}
