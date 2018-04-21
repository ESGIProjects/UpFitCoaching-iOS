//
//  AppDelegate.swift
//  Coaching
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
		center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
			print("Granted:", granted, "Error:", error?.localizedDescription ?? "none")
		}
		
//		let dateFormatter = DateFormatter()
//		dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZ"
//		print(dateFormatter.string(from: Date()))
//		
//		print(dateFormatter.date(from: "2018-04-20 17:00:00+0200")?.timeIntervalSinceNow)
		
		if let user = Database().getCurrentUser() {
			// Show the corresponding tab bar controller
			window?.rootViewController = user.type == nil ? UITabBarController.coachController() : UITabBarController.clientController()
			
			// Download new messages
			// ...
			
			// Starts websocket
			MessagesDelegate.instance.delegate = self
			MessagesDelegate.instance.connect()
		} else {
			// Show login
			window?.rootViewController = UINavigationController(rootViewController: LoginController())
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
		print(#function, error ?? "")
	}
	
	func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
		print(#function)
		
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd"
		let decoder = JSONDecoder()
		decoder.dateDecodingStrategy = .formatted(dateFormatter)
		
		guard let json = text.data(using: .utf8) else {  return }
		guard let message = try? decoder.decode(Message.self, from: json) else { print("decoder error"); return }
		guard message.messageID != nil else { return }

		// Create a local notification
		let content = UNMutableNotificationContent()
		content.title = "Jason Pierna"
		content.body = message.content
		content.sound = UNNotificationSound.default()

		// Add the notification to the queue, for immediate firing
		let request = UNNotificationRequest(identifier: "message", content: content, trigger: nil)
		center.add(request)
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
