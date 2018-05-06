//
//  TypeRegisterController.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 06/05/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit

class TypeRegisterController: UIViewController {
	
	lazy var clientButton = UI.clientButton(registerController, action: #selector(RegisterController.clientTapped))
	lazy var coachButton = UI.coachButton(registerController, action: #selector(RegisterController.coachTapped))
	
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
		view.addSubview(clientButton)
		view.addSubview(coachButton)
		
		NSLayoutConstraint.activate(getConstraints())
	}
}
