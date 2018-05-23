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
		class func clientButton() -> UIButton {
			let view = UIButton(type: .system)
			view.translatesAutoresizingMaskIntoConstraints = false
			
			view.setTitle("clientButton".localized, for: .normal)

			return view
		}
		
		class func coachButton() -> UIButton {
			let view = UIButton(type: .system)
			view.translatesAutoresizingMaskIntoConstraints = false
			
			view.setTitle("coachButton".localized, for: .normal)

			return view
		}
	}
	
	fileprivate func getConstraints() -> [NSLayoutConstraint] {
		return [
			clientButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			clientButton.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: -10.0),
			
			coachButton.topAnchor.constraint(equalTo: view.centerYAnchor, constant: 10.0),
			coachButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
		]
	}
	
	fileprivate func setUIComponents() {
		clientButton = UI.clientButton()
		clientButton.addTarget(self, action: #selector(next(_:)), for: .touchUpInside)
		
		coachButton = UI.coachButton()
		coachButton.addTarget(self, action: #selector(next(_:)), for: .touchUpInside)
	}
	
	func setupLayout() {
		setUIComponents()
		
		view.addSubview(clientButton)
		view.addSubview(coachButton)
		
		NSLayoutConstraint.activate(getConstraints())
	}
}
