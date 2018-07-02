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
import PKHUD

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
		
		// Setting up PKHUD
		PKHUD.sharedHUD.dimsBackground = false
		
		return true
	}
	
	func applicationDidBecomeActive(_ application: UIApplication) {		
		application.applicationIconBadgeNumber = 0
		UNUserNotificationCenter.current().removeAllDeliveredNotifications()
		
		// Pull data
		if let user = Database().getCurrentUser() {
			pullData(user: user)
		}
	}
	
	func pullData(user: User) {
		let dispatchGroup = DispatchGroup()
		
		Downloader.messages(for: user, in: dispatchGroup)
		Downloader.events(for: user, in: dispatchGroup)
		Downloader.threads(in: dispatchGroup)
		
		if user.type == 0 || user.type == 1 {
			// Download appraisal, measurements & tests
			Downloader.appraisal(for: user, in: dispatchGroup)
			Downloader.measurements(for: user, in: dispatchGroup)
			Downloader.tests(for: user, in: dispatchGroup)
		}
		
		dispatchGroup.notify(queue: .main) {
			if user.type == 0 || user.type == 1 {
				NotificationCenter.default.post(name: .followUpDownloaded, object: nil)
			}
		}
	}
}
