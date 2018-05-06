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
		
		// MARK: - Main
		
		class func pageViewController(delegate: UIPageViewControllerDelegate? = nil, dataSource: UIPageViewControllerDataSource? = nil) -> UIPageViewController {
			let controller = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
			controller.view.translatesAutoresizingMaskIntoConstraints = false
			
			controller.delegate = delegate
			controller.dataSource = dataSource
			
			return controller
		}
	}
	
	func getConstraints() {
		
	}
}
