//
//  DetailsRegisterController.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 21/05/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
// Version 1.0

import UIKit
import Eureka

class DetailsRegisterController: FormViewController {
	
	weak var registerController: RegisterController?
	var type: Int?
	
	var firstNameRow: NameRow!
	var lastNameRow: NameRow!
	var sexRow: SegmentedRow<Int>!
	var cityRow: TextRow!
	var phoneNumberRow: PhoneRow!
	var addressRow: TextRow?
	var birthDateRow: DateInlineRow?
	var registerRow: ButtonRow!
	
	convenience init(registerController: RegisterController) {
		self.init()
		
		self.registerController = registerController
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()		
		setupLayout()
	}
	
	@objc func register() {
		let validationErrors = form.validate()
		
		if validationErrors.isEmpty {
			registerController?.register()
		} else {
			guard let error = validationErrors.first else { return }
			registerController?.presentAlert(title: error.msg, message: nil)
		}
	}
}
