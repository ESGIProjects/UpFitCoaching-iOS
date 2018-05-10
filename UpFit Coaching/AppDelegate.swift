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
			// Show the corresponding tab bar controller
			window?.rootViewController = UITabBarController.getRootViewController(for: user)
			
			// Starts websocket
			MessagesDelegate.instance.delegate = self
			MessagesDelegate.instance.connect()
		} else {
			// Show login
			window?.rootViewController = UINavigationController(rootViewController: LoginController())
//			window?.rootViewController = Chart()
		}
		
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
		
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
		let decoder = JSONDecoder()
		decoder.dateDecodingStrategy = .formatted(dateFormatter)
		
		guard let json = text.data(using: .utf8) else {  return }
		guard let message = try? decoder.decode(Message.self, from: json) else { print("decoder error"); return }
		guard message.messageID != nil else { return }
		
		// Save message
		Database().createOrUpdate(model: message, with: MessageObject.init)

		// Fire notification
		MessagesDelegate.fireNotification(message: message)
	}
	
	func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
		print(#function)
	}
}

// MARK: - UNUserNotificationCenterDelegate
extension AppDelegate: UNUserNotificationCenterDelegate {
	func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
		if notification.request.identifier == "message" {
			completionHandler([.alert, .sound, .badge])
		} else {
			completionHandler([.alert, .sound])
		}
	}
}
