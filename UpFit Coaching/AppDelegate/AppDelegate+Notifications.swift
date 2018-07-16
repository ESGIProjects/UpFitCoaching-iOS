//
//  AppDelegate+Notifications.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 09/06/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
// Version 1.0

import UIKit
import UserNotifications
import Firebase

extension AppDelegate {
	func configureFirebase(_ application: UIApplication) {
		FirebaseApp.configure()
		Messaging.messaging().delegate = self
		application.registerForRemoteNotifications()
	}
	
	func requestFirebaseToken() {
		guard let token = InstanceID.instanceID().token() else { return }
		registerToken(token)
	}
	
	fileprivate func registerToken(_ token: String) {
		guard let currentUser = Database().getCurrentUser() else { return }
		let oldToken = UserDefaults.standard.object(forKey: "firebaseToken") as? String
		
		if oldToken == nil || token != oldToken {
			UserDefaults.standard.set(token, forKey: "firebaseToken")
			Network.registerToken(token, oldToken: oldToken, for: currentUser)
		}
	}
}

// MARK: - MessagingDelegate
extension AppDelegate: MessagingDelegate {
	func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
		registerToken(fcmToken)
	}
	
	func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
		print("Received data message: \(remoteMessage.appData)")
	}
}

// MARK: - UNUserNotificationCenterDelegate
extension AppDelegate: UNUserNotificationCenterDelegate {
	func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
		let userInfo = notification.request.content.userInfo
		
		if let aps = userInfo["aps"] as? [String: Any],
			let type = aps["type"] as? String,
			type == "message",
			MessagesDelegate.instance.displayMode == .hide {
			completionHandler([.sound, .badge])
		} else {
			completionHandler([.alert, .sound, .badge])
		}
	}
}
