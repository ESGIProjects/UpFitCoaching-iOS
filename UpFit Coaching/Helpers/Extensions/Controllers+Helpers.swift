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
		
		// Common controllers
		let calendarController = CalendarController()
		calendarController.tabBarItem = UITabBarItem(title: "calendarController_title".localized, image: #imageLiteral(resourceName: "calendarTab"), tag: 0)
		viewControllers.append(calendarController)
		
		let forumController = ForumController()
		forumController.tabBarItem = UITabBarItem(title: "forumController_title".localized, image: #imageLiteral(resourceName: "forumTab"), tag: 1)
		viewControllers.append(forumController)
		
		let settingsController = SettingsController()
		settingsController.tabBarItem = UITabBarItem(title: "settingsController_title".localized, image: #imageLiteral(resourceName: "settingsTab"), tag: 2)
		viewControllers.append(settingsController)
		
		// User-type specific views
		if user.type == 2 {
			let conversationListController = ConversationListController()
			conversationListController.tabBarItem = UITabBarItem(title: "conversationListController_title".localized, image: #imageLiteral(resourceName: "messagesTab"), tag: 3)
			viewControllers.insert(conversationListController, at: 1)
			
			let clientsListController = ClientsListController()
			clientsListController.tabBarItem = UITabBarItem(title: "clientsListController_title".localized, image: #imageLiteral(resourceName: "clientsTab"), tag: 4)
			viewControllers.insert(clientsListController, at: 0)
		} else if let otherUser = user.coach {
			let conversationController = ConversationController()
			conversationController.otherUser = otherUser
			conversationController.tabBarItem = UITabBarItem(title: "conversationListController_title".localized, image: #imageLiteral(resourceName: "messagesTab"), tag: 3)
			viewControllers.insert(conversationController, at: 1)
		}
		
		// Follow Up
		if user.type == 0 || user.type == 1 {
			let followUpController = FollowUpController()
			followUpController.user = user
			followUpController.tabBarItem = UITabBarItem(title: "followUpController_title".localized, image: #imageLiteral(resourceName: "followUp"), tag: 4)
			viewControllers.insert(followUpController, at: 0)
		}
		
		// Creating the tab bar controller
		let selectedIndex = viewControllers.index(of: calendarController) ?? 0
		viewControllers = viewControllers.map { UINavigationController(rootViewController: $0) }
		
		let tabBarController = UITabBarController()
		tabBarController.setViewControllers(viewControllers, animated: true)
		tabBarController.selectedIndex = selectedIndex
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
	
	func processLogin(for user: User, completion: (() -> Void)? = nil) {
		// Save user info
		Database().createOrUpdate(model: user, with: UserObject.init)
		UserDefaults.standard.set(user.userID, forKey: "userID")
		
		// Present the correct controller for the user
		let tabBarController = UITabBarController.getRootViewController(for: user)
		
		// Start notifications
		(UIApplication.shared.delegate as? AppDelegate)?.requestFirebaseToken()
		
		// Download everything
		(UIApplication.shared.delegate as? AppDelegate)?.pullData(user: user)
		
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
