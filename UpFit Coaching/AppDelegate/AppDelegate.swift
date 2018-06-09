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
	let center = UNUserNotificationCenter.current()

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		
		// Creating app window
		window = UIWindow(frame: UIScreen.main.bounds)
		window?.backgroundColor = .white
		
		// Request notifications authorization
		center.delegate = self
		center.requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in }
		
		if let user = Database().getCurrentUser() {
			// Show the tab bar controller
			window?.rootViewController = UITabBarController.getRootViewController(for: user)
			
			// Starts websocket
			MessagesDelegate.instance.delegate = self
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

// MARK: - WebSocketDelegate
extension AppDelegate: WebSocketDelegate {
	func websocketDidConnect(socket: WebSocketClient) {
		print(#function)
	}
	
	func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
		print(#function, error ?? "", error?.localizedDescription ?? "")
	}
	
	func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
		print(#function)
		
		guard let message = MessagesDelegate.decode(from: text), message.messageID != nil else { return }
		
		// Save message
		Database().createOrUpdate(model: message, with: MessageObject.init)

		// Fire notification
		MessagesDelegate.fireNotification(message: message)
	}
	
	func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
		print(#function)
	}
}
