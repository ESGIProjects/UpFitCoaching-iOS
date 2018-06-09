//
//  AppDelegate.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 13/02/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit
import UserNotifications

import RealmSwift
import Starscream

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		
		// Creating app window
		window = UIWindow(frame: UIScreen.main.bounds)
		window?.backgroundColor = .white
		
		// Set UserNotificationCenter delegate
		UNUserNotificationCenter.current().delegate = self
		
		if let user = Database().getCurrentUser() {
			// Show the tab bar controller
			window?.rootViewController = UITabBarController.getRootViewController(for: user)
			
			// Starts websocket
			MessagesDelegate.instance.connect()
		} else {
			// Show login screen
			window?.rootViewController = UINavigationController(rootViewController: LoginController())
		}
		
		configureFirebase(application)
		window?.makeKeyAndVisible()
		
		return true
	}
}
