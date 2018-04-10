//
//  Helpers.swift
//  Coaching
//
//  Created by Jason Pierna on 10/04/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit

extension UIAlertController {
	class func simpleAlert(title: String?, message: String?) -> UIAlertController {
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "OK_button".localized, style: .default))
		return alert
	}
}

extension UITabBarController {
	class func coachController() -> UITabBarController {
		
		var viewControllers = [UIViewController]()
		
		let conversationListController = ConversationListController()
		conversationListController.tabBarItem = UITabBarItem(title: "conversationList_title".localized, image: #imageLiteral(resourceName: "chat"), tag: 1)
		viewControllers.append(conversationListController)
		
		let settingsController = SettingsController()
		settingsController.tabBarItem = UITabBarItem(title: "Settings", image: #imageLiteral(resourceName: "settings"), tag: 2)
		viewControllers.append(settingsController)
		
		viewControllers = viewControllers.map { UINavigationController(rootViewController: $0) }
		
		let tabBarController = UITabBarController()
		tabBarController.setViewControllers(viewControllers, animated: true)
		return tabBarController
	}
	
	class func clientController() -> UITabBarController {
		return UITabBarController()
	}
}
