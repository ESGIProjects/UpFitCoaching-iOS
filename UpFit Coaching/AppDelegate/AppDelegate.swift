//
//  AppDelegate.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 13/02/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
// Version 1.0

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
		
		// Set appearance
		setGlobalAppearance()
		
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
			Downloader.prescriptions(for: user, in: dispatchGroup)
		}
		
		dispatchGroup.notify(queue: .main) {
			if user.type == 0 || user.type == 1 {
				NotificationCenter.default.post(name: .followUpDownloaded, object: nil)
			}
		}
	}
	
	private func setGlobalAppearance() {
		// UINavigationBar
		UINavigationBar.appearance().barTintColor = UIColor(red: 12.0/255.0, green: 200.0/255.0, blue: 165.0/255.0, alpha: 1.0)
		UINavigationBar.appearance().tintColor = .white
		UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
		if #available(iOS 11.0, *) {
			UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
		}
		
		// UITabBar
		UITabBar.appearance().barTintColor = UIColor(red: 12.0/255.0, green: 200.0/255.0, blue: 165.0/255.0, alpha: 1.0)
		UITabBar.appearance().tintColor = .white
		UITabBar.appearance().unselectedItemTintColor = UIColor(red: 17.0/255.0, green: 142.0/255.0, blue: 135.0/255.0, alpha: 1.0)
		
		// UISegmentedControl
		UISegmentedControl.appearance().tintColor = UIColor(red: 12.0/255.0, green: 200.0/255.0, blue: 165.0/255.0, alpha: 1.0)
		
		// UIToolbar
		UIToolbar.appearance().barTintColor = UIColor(red: 12.0/255.0, green: 200.0/255.0, blue: 165.0/255.0, alpha: 1.0)
	}
}
