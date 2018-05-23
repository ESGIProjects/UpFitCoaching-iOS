//
//  Controllers.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 10/04/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit

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
		
		// Calendar
		let calendarController = CalendarController()
		calendarController.tabBarItem = UITabBarItem(title: "calendar_title".localized, image: #imageLiteral(resourceName: "calendar"), tag: 0)
		viewControllers.append(calendarController)
		
		// Messages
		if user.type == 2 {
			// Conversation List
			let conversationListController = ConversationListController()
			conversationListController.tabBarItem = UITabBarItem(title: "conversationList_title".localized, image: #imageLiteral(resourceName: "chat"), tag: 1)
			viewControllers.append(conversationListController)
		} else if let otherUser = user.coach {
			// Conversation with coach
			let conversationController = ConversationController()
			conversationController.otherUser = otherUser
			conversationController.title = "\(otherUser.firstName) \(otherUser.lastName)"
			
			conversationController.tabBarItem = UITabBarItem(title: "conversationList_title".localized, image: #imageLiteral(resourceName: "chat"), tag: 0)
			viewControllers.append(conversationController)
		}
		
		// Settings
		let settingsController = SettingsController()
		settingsController.tabBarItem = UITabBarItem(title: "settings_title".localized, image: #imageLiteral(resourceName: "settings"), tag: 2)
		viewControllers.append(settingsController)
		
		// Creating the tab bar controller
		viewControllers = viewControllers.map { UINavigationController(rootViewController: $0) }
		
		let tabBarController = UITabBarController()
		tabBarController.setViewControllers(viewControllers, animated: true)
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
}
