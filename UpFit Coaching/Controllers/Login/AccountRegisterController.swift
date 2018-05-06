//
//  AccountRegisterController.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 06/05/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit

class AccountRegisterController: UIViewController {
	
	lazy var mailTextField = UI.mailTextField()
	lazy var passwordTextField = UI.passwordTextField()
	lazy var confirmPasswordTextField = UI.confirmPasswordTextField()
	lazy var nextButton = UI.nextButton(registerController, action: #selector(RegisterController.nextToDetails))
	
	weak var registerController: RegisterController?
	
	convenience init(registerController: RegisterController?) {
		self.init()
		self.registerController = registerController
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupLayout()
	}
	
	private func setupLayout() {
		view.addSubview(mailTextField)
		view.addSubview(passwordTextField)
		view.addSubview(confirmPasswordTextField)
		view.addSubview(nextButton)
		
		NSLayoutConstraint.activate(getConstraints())
	}
}
