//
//  AppDelegate.swift
//  Coaching
//
//  Created by Jason Pierna on 13/02/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		
		window = UIWindow(frame: UIScreen.main.bounds)
		window?.backgroundColor = .white
		
		if let user = UserDefaults.standard.object(forKey: "usertype") as? String {
			// Show the corresponding tab bar controller
			window?.rootViewController = user == "coach" ? UITabBarController.coachController() : UITabBarController.clientController()
		} else {
			// Show login
			window?.rootViewController = UINavigationController(rootViewController: LoginController())
		}
		
		window?.makeKeyAndVisible()
		
		return true
	}
}
