//
//  Controllers.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 10/04/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit
import UserNotifications

extension UIAlertController {
	class func simpleAlert(title: String?, message: String?) -> UIAlertController {
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "OKButton".localized, style: .default))
		return alert
	}
}

extension UITabBarController {
	class func getRootViewController(for user: User) -> UITabBarController {
		var viewControllers = [UIViewController]()
		
		// Follow Up
		let followUpController = FollowUpController()
		followUpController.tabBarItem = UITabBarItem(title: "followUpController_title".localized, image: #imageLiteral(resourceName: "followUp"), tag: 0)
		viewControllers.append(followUpController)
		
		// Calendar
		let calendarController = CalendarController()
		calendarController.tabBarItem = UITabBarItem(title: "calendarController_title".localized, image: #imageLiteral(resourceName: "calendar"), tag: 1)
		viewControllers.append(calendarController)
		
		// Messages
		if user.type == 2 {
			// Conversation List
			let conversationListController = ConversationListController()
			conversationListController.tabBarItem = UITabBarItem(title: "conversationListController_title".localized, image: #imageLiteral(resourceName: "chat"), tag: 2)
			viewControllers.append(conversationListController)
		} else if let otherUser = user.coach {
			// Conversation with coach
			let conversationController = ConversationController()
			conversationController.otherUser = otherUser
			conversationController.title = "\(otherUser.firstName) \(otherUser.lastName)"
			
			conversationController.tabBarItem = UITabBarItem(title: "conversationListController_title".localized, image: #imageLiteral(resourceName: "chat"), tag: 2)
			viewControllers.append(conversationController)
		}
		
		// Forum
		let forumController = ForumController()
		forumController.tabBarItem = UITabBarItem(title: "forumController_title".localized, image: #imageLiteral(resourceName: "forum"), tag: 3)
		viewControllers.append(forumController)
		
		// Settings
		let settingsController = SettingsController()
		settingsController.tabBarItem = UITabBarItem(title: "settingsController_title".localized, image: #imageLiteral(resourceName: "settings"), tag: 4)
		viewControllers.append(settingsController)
		
		// Creating the tab bar controller
		viewControllers = viewControllers.map { UINavigationController(rootViewController: $0) }
		
		let tabBarController = UITabBarController()
		tabBarController.setViewControllers(viewControllers, animated: true)
		tabBarController.selectedIndex = 1
		return tabBarController
	}
}
extension UIViewController {
	func presentAlert(title: String?, message: String?) {
		
		let alert = UIAlertController.simpleAlert(title: title, message: message)
		
		DispatchQueue.main.async { [weak self] in
			self?.present(alert, animated: true)
		}
	}
	
	// swiftlint:disable large_tuple
	func getAnchors() -> (top: NSLayoutYAxisAnchor, bottom: NSLayoutYAxisAnchor, leading: NSLayoutXAxisAnchor, trailing: NSLayoutXAxisAnchor) {
		
		if #available(iOS 11.0, *) {
			return (view.safeAreaLayoutGuide.topAnchor,
					view.safeAreaLayoutGuide.bottomAnchor,
					view.safeAreaLayoutGuide.leadingAnchor,
					view.safeAreaLayoutGuide.trailingAnchor)
		} else {
			return (view.topAnchor,
					view.bottomAnchor,
					view.leadingAnchor,
					view.trailingAnchor)
		}
	}
	// swiftlint: enable large_tuple
	
	func processLogin(for user: User, completion: (() -> Void)? = nil) {
		// Save user info
		Database().createOrUpdate(model: user, with: UserObject.init)
		UserDefaults.standard.set(user.userID, forKey: "userID")
		
		// Present the correct controller for the user
		let tabBarController = UITabBarController.getRootViewController(for: user)
		
		// Start notifications
		(UIApplication.shared.delegate as? AppDelegate)?.requestFirebaseToken()
		
		// Start websocket
		MessagesDelegate.instance.connect()
		
		DispatchQueue.main.async { [weak self] in
			self?.present(tabBarController, animated: true) {
				completion?()
				UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in }
			}
		}
	}
}
