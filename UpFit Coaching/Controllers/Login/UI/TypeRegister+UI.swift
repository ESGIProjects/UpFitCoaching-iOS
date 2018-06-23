//
//  TypeRegister+UI.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 06/05/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit

extension TypeRegisterController {	
	fileprivate func getConstraints() -> [NSLayoutConstraint] {
		return [
			clientButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			clientButton.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: -10.0),
			
			coachButton.topAnchor.constraint(equalTo: view.centerYAnchor, constant: 10.0),
			coachButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
		]
	}
	
	fileprivate func setUIComponents() {
		clientButton = UI.genericButton
		clientButton.addTarget(self, action: #selector(next(_:)), for: .touchUpInside)
		clientButton.titleText = "clientButton".localized
		
		coachButton = UI.genericButton
		coachButton.addTarget(self, action: #selector(next(_:)), for: .touchUpInside)
		coachButton.titleText = "coachButton".localized
	}
	
	func setupLayout() {
		setUIComponents()
		
		view.addSubview(clientButton)
		view.addSubview(coachButton)
		
		NSLayoutConstraint.activate(getConstraints())
	}
}
