//
//  TypeRegister+UI.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 06/05/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit

extension TypeRegisterController {
	class UI {
		class func clientButton(_ target: Any?, action: Selector) -> UIButton {
			let view = UIButton(type: .system)
			view.translatesAutoresizingMaskIntoConstraints = false
			view.setTitle("Client", for: .normal)
			view.addTarget(target, action: action, for: .touchUpInside)
			return view
		}
		
		class func coachButton(_ target: Any?, action: Selector) -> UIButton {
			let view = UIButton(type: .system)
			view.translatesAutoresizingMaskIntoConstraints = false
			view.setTitle("Coach", for: .normal)
			view.addTarget(target, action: action, for: .touchUpInside)
			return view
		}
	}
	
	func getConstraints() -> [NSLayoutConstraint] {
		return [
			clientButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			clientButton.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: -10.0),
			
			coachButton.topAnchor.constraint(equalTo: view.centerYAnchor, constant: 10.0),
			coachButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
		]
	}
}
