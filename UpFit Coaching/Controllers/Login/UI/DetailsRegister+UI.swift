//
//  DetailsRegister+UI.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 06/05/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit

extension DetailsRegisterController {
	class UI {
		class func firstNameTextField() -> UITextField {
			let textField = UITextField(frame: .zero)
			textField.translatesAutoresizingMaskIntoConstraints = false
			textField.borderStyle = .roundedRect
			textField.returnKeyType = .next
			textField.autocorrectionType = .no
			textField.placeholder = "firstName_placeholder".localized
			return textField
		}
		
		class func lastNameTextField() -> UITextField {
			let textField = UITextField(frame: .zero)
			textField.translatesAutoresizingMaskIntoConstraints = false
			textField.borderStyle = .roundedRect
			textField.keyboardType = .emailAddress
			textField.returnKeyType = .next
			textField.autocorrectionType = .no
			textField.placeholder = "lastName_placeholder".localized
			return textField
		}
		
		class func cityTextField() -> UITextField {
			let textField = UITextField(frame: .zero)
			textField.translatesAutoresizingMaskIntoConstraints = false
			textField.borderStyle = .roundedRect
			textField.keyboardType = .emailAddress
			textField.returnKeyType = .next
			textField.autocorrectionType = .no
			textField.placeholder = "city_placeholder".localized
			return textField
		}
		
		class func phoneNumberTextField() -> UITextField {
			let textField = UITextField(frame: .zero)
			textField.translatesAutoresizingMaskIntoConstraints = false
			textField.borderStyle = .roundedRect
			textField.keyboardType = .emailAddress
			textField.returnKeyType = .next
			textField.autocorrectionType = .no
			textField.placeholder = "phoneNumber_placeholder".localized
			return textField
		}
		
		class func birthDateTextField() -> UITextField { // temporary
			let textField = UITextField(frame: .zero)
			textField.translatesAutoresizingMaskIntoConstraints = false
			textField.borderStyle = .roundedRect
			textField.keyboardType = .emailAddress
			textField.returnKeyType = .next
			textField.autocorrectionType = .no
			textField.placeholder = "birthDate_placeholder".localized
			return textField
		}
		
		class func addressTextField() -> UITextField {
			let textField = UITextField(frame: .zero)
			textField.translatesAutoresizingMaskIntoConstraints = false
			textField.borderStyle = .roundedRect
			textField.keyboardType = .emailAddress
			textField.returnKeyType = .next
			textField.autocorrectionType = .no
			textField.placeholder = "address_placeholder".localized
			return textField
		}
		
		class func registerButton(_ target: Any?, action: Selector) -> UIButton {
			let view = UIButton(type: .system)
			view.translatesAutoresizingMaskIntoConstraints = false
			view.setTitle("Register", for: .normal)
			view.addTarget(target, action: action, for: .touchUpInside)
			return view
		}
	}
	
	func getConstraints() -> [NSLayoutConstraint] {
		let anchors = getAnchors()
		
		var constraints = [
			firstNameTextField.topAnchor.constraint(equalTo: anchors.top),
			firstNameTextField.leadingAnchor.constraint(equalTo: anchors.leading, constant: 10.0),
			firstNameTextField.trailingAnchor.constraint(equalTo: anchors.trailing, constant: -10.0),
			
			lastNameTextField.topAnchor.constraint(equalTo: firstNameTextField.bottomAnchor, constant: 10.0),
			lastNameTextField.leadingAnchor.constraint(equalTo: anchors.leading, constant: 10.0),
			lastNameTextField.trailingAnchor.constraint(equalTo: anchors.trailing, constant: -10.0),
			
			cityTextField.topAnchor.constraint(equalTo: lastNameTextField.bottomAnchor, constant: 10.0),
			cityTextField.leadingAnchor.constraint(equalTo: anchors.leading, constant: 10.0),
			cityTextField.trailingAnchor.constraint(equalTo: anchors.trailing, constant: -10.0),
			
			phoneNumberTextField.topAnchor.constraint(equalTo: cityTextField.bottomAnchor, constant: 10.0),
			phoneNumberTextField.leadingAnchor.constraint(equalTo: anchors.leading, constant: 10.0),
			phoneNumberTextField.trailingAnchor.constraint(equalTo: anchors.trailing, constant: -10.0),
			
			registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
		]
		
		if type == 2 {
			constraints += [
				addressTextField.topAnchor.constraint(equalTo: phoneNumberTextField.bottomAnchor, constant: 10.0),
				addressTextField.leadingAnchor.constraint(equalTo: anchors.leading, constant: 10.0),
				addressTextField.trailingAnchor.constraint(equalTo: anchors.trailing, constant: -10.0),
				
				registerButton.topAnchor.constraint(equalTo: addressTextField.bottomAnchor, constant: 10.0)
			]
		} else {
			constraints += [
				birthDateTextField.topAnchor.constraint(equalTo: phoneNumberTextField.bottomAnchor, constant: 10.0),
				birthDateTextField.leadingAnchor.constraint(equalTo: anchors.leading, constant: 10.0),
				birthDateTextField.trailingAnchor.constraint(equalTo: anchors.trailing, constant: -10.0),
				
				registerButton.topAnchor.constraint(equalTo: birthDateTextField.bottomAnchor, constant: 10.0)
			]
		}
	
		return constraints
	}
}
