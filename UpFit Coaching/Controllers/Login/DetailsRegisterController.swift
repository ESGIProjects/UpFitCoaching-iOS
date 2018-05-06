//
//  DetailsRegisterController.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 06/05/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit

class DetailsRegisterController: UIViewController {
	
	lazy var firstNameTextField = UI.firstNameTextField()
	lazy var lastNameTextField = UI.lastNameTextField()
	lazy var cityTextField = UI.cityTextField()
	lazy var phoneNumberTextField = UI.phoneNumberTextField()
	lazy var birthDateTextField = UI.birthDateTextField()
	lazy var addressTextField = UI.addressTextField()
	lazy var registerButton = UI.registerButton(registerController, action: #selector(RegisterController.register))

	weak var registerController: RegisterController?
	var type: Int?
	
	convenience init(registerController: RegisterController?, type: Int?) {
		self.init()
		self.registerController = registerController
		self.type = type
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupLayout()
	}
	
	private func setupLayout() {
		view.addSubview(firstNameTextField)
		view.addSubview(lastNameTextField)
		view.addSubview(cityTextField)
		view.addSubview(phoneNumberTextField)
		view.addSubview(registerButton)
		
		if type == 2 {
			view.addSubview(addressTextField)
		} else {
			view.addSubview(birthDateTextField)
		}
		
		NSLayoutConstraint.activate(getConstraints())
	}
}
