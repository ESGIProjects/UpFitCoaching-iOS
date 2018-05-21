//
//  DetailsRegisterController.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 21/05/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit
import Eureka

class NewDetailsRegisterController: FormViewController {
	
	weak var registerController: RegisterController?
	var type: Int?
	
	convenience init(registerController: RegisterController, type: Int?) {
		self.init()
		
		self.registerController = registerController
		self.type = type
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupLayout()
	}
	
	func setupLayout() {
		let nameSection = Section()
		
		nameSection <<< NameRow("firstName") {
			$0.title = "First name"
			$0.placeholder = "firstName_placeholder".localized
			$0.value = registerController?.registerBox.firstName
			$0.onChange { [unowned self] row in
				if let value = row.value {
					self.registerController?.registerBox.firstName = value
				}
			}
		}
		
		nameSection <<< NameRow("lastName") {
			$0.title = "Last name"
			$0.placeholder = "lastName_placeholder".localized
			$0.value = registerController?.registerBox.firstName
			$0.onChange { [unowned self] row in
				if let value = row.value {
					self.registerController?.registerBox.firstName = value
				}
			}
		}
		
		form +++ nameSection
		
		let detailsSection = Section()
		detailsSection.hidden = Condition.function([]) { form in
			return false
		}
		
		detailsSection <<< TextRow("city") {
			$0.title = "City"
		}
		
		detailsSection <<< PhoneRow("phoneNumber") {
			$0.title = "Phone number"
		}
		
		if type == 2 {
			detailsSection <<< TextRow("address") {
				$0.title = "Address"
			}
		} else {
			detailsSection <<< DateInlineRow("birthDate") {
				$0.title = "Birth date"
			}
		}
		
		form +++ detailsSection
	}
	
	@objc func register() {
		let validationErrors = form.validate()
		
		if validationErrors.isEmpty {
//			registerController?.register()
			print("Register ok!!")
		} else {
			guard let error = validationErrors.first else { return }
			registerController?.presentAlert(title: error.msg, message: nil)
		}
	}
}
