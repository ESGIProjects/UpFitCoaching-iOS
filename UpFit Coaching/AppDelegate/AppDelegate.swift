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
			
//			pullData(user: user)
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
	}
	
	fileprivate func pullData(user: User) {
		let dispatchGroup = DispatchGroup()
		
		dispatchGroup.enter()
		Network.getMessages(for: user) { data, _, _ in
			guard let data = data else { return }
			
			print(String(data: data, encoding: .utf8) ?? "no messages")
			dispatchGroup.leave()
		}
		
		dispatchGroup.enter()
		Network.getEvents(for: user) { data, _, _ in
			guard let data = data else { return }
			
			print(String(data: data, encoding: .utf8) ?? "no events")
			dispatchGroup.leave()
		}
		
		dispatchGroup.enter()
		Network.getThreads(for: 1) { data, _, _ in
			guard let data = data else { return }
			
			print(String(data: data, encoding: .utf8) ?? "no threads")
			dispatchGroup.leave()
		}
		
		dispatchGroup.notify(queue: .main) {
			print("TASKS COMPLETE!!!!!")
		}
	}
}
