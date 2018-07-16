//
//  TypeRegisterController.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 06/05/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
// Version 1.0

import UIKit

class TypeRegisterController: UIViewController {
	
	var clientButton: UIButton!
	var coachButton: UIButton!
	
	weak var registerController: RegisterController?
	
	convenience init(registerController: RegisterController?) {
		self.init()
		self.registerController = registerController
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupLayout()
	}
	
	@objc func next(_ sender: UIButton) {
		if sender == clientButton {
			registerController?.type = 0
			registerController?.registerBox.type = 0
		} else {
			registerController?.type = 2
			registerController?.registerBox.type = 2
		}
		
		registerController?.goToAccount(.forward)
	}
}
