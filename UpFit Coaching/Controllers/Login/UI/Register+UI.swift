//
//  Register+UI.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 06/05/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit

extension RegisterController {
	class UI {
		class func pageViewController(delegate: UIPageViewControllerDelegate? = nil, dataSource: UIPageViewControllerDataSource? = nil) -> UIPageViewController {
			let controller = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
			controller.view.translatesAutoresizingMaskIntoConstraints = false
			
			return controller
		}
	}
	
	func getConstraints() -> [NSLayoutConstraint] {
		let anchors = getAnchors()
		
		return [
			pageViewController.view.topAnchor.constraint(equalTo: anchors.top),
			pageViewController.view.bottomAnchor.constraint(equalTo: anchors.bottom),
			pageViewController.view.leadingAnchor.constraint(equalTo: anchors.leading),
			pageViewController.view.trailingAnchor.constraint(equalTo: anchors.trailing)
		]
	}
	
	func setUIComponents() {
		pageViewController = UI.pageViewController()
		typeController = TypeRegisterController(registerController: self)
		accountController = AccountRegisterController(registerController: self)
		detailsController = DetailsRegisterController(registerController: self, type: type)
	}
	
	func setupLayout() {
		setUIComponents()
		
		addChildViewController(pageViewController)
		view.addSubview(pageViewController.view)
		
		NSLayoutConstraint.activate(getConstraints())
		
		pageViewController.setViewControllers([typeController], direction: .forward, animated: true)
		pageViewController.didMove(toParentViewController: self)
	}
}
