//
//  RegisterController.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 06/05/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit
import CryptoSwift

class RegisterController: UIViewController {
	
	// MARK: - UI
	
	lazy var pageViewController = UI.pageViewController()
	lazy var typeController = TypeRegisterController(registerController: self)
	lazy var accountController = AccountRegisterController(registerController: self)
	lazy var detailsController = DetailsRegisterController(registerController: self, type: type)
	
	// MARK: - Data
	
	var type: Int?
	var parameters = [String: Any]()
	
	// MARK: - UIViewController
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Layout
		title = "signUpController_title".localized
		view.backgroundColor = .white
		setupLayout()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		navigationController?.setNavigationBarHidden(false, animated: true)
	}
	
	// MARK: - Layout
	
	private func setupLayout() {
		addChildViewController(pageViewController)
		view.addSubview(pageViewController.view)
		
		NSLayoutConstraint.activate([
			pageViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
			pageViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			pageViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			pageViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
			])
		
		pageViewController.setViewControllers([typeController], direction: .forward, animated: true)
		pageViewController.didMove(toParentViewController: self)
	}
	
	// MARK: - Actions
	
	@objc func clientTapped() {
		type = 0
		parameters["type"] = 0
		
		nextToAccount()
	}
	
	@objc func coachTapped() {
		type = 2
		parameters["type"] = 2
		
		nextToAccount()
	}
	
	func nextToAccount() {
		pageViewController.setViewControllers([accountController], direction: .forward, animated: true)
	}
	
	@objc func nextToDetails() {
		
		// Check the existence of every field
		
		guard let mail = accountController.mailTextField.text, mail != "" else {
			present(UIAlertController.simpleAlert(title: "mail_missing_title".localized, message: nil), animated: true)
			return
		}
		parameters["mail"] = mail
		
		guard let password = accountController.passwordTextField.text, password != "" else {
			present(UIAlertController.simpleAlert(title: "password_missing_title".localized, message: nil), animated: true)
			return
		}
		parameters["password"] = password.sha256()
		
		guard let confirmPassword = accountController.confirmPasswordTextField.text, password == confirmPassword else {
			present(UIAlertController.simpleAlert(title: "confirmPassword_error_title".localized, message: nil), animated: true)
			return
		}
		
		pageViewController.setViewControllers([detailsController], direction: .forward, animated: true)
	}
	
	@objc func register() {
		
		// Check the existence of every field
		
		guard let firstName = detailsController.firstNameTextField.text, firstName != "" else {
			present(UIAlertController.simpleAlert(title: "firstName_missing_title".localized, message: nil), animated: true)
			return
		}
		parameters["firstName"] = firstName
		
		guard let lastName = detailsController.lastNameTextField.text, lastName != "" else {
			present(UIAlertController.simpleAlert(title: "lastName_missing_title".localized, message: nil), animated: true)
			return
		}
		parameters["lastName"] = lastName
		
		guard let city = detailsController.cityTextField.text, city != "" else {
			present(UIAlertController.simpleAlert(title: "city_missing_title".localized, message: nil), animated: true)
			return
		}
		parameters["city"] = city
		
		guard let phoneNumber = detailsController.phoneNumberTextField.text, phoneNumber != "" else {
			present(UIAlertController.simpleAlert(title: "phoneNumber_missing_title".localized, message: nil), animated: true)
			return
		}
		parameters["phoneNumber"] = phoneNumber
		
		if type == 2 {
			guard let address = detailsController.addressTextField.text, address != "" else {
				present(UIAlertController.simpleAlert(title: "address_missing_title".localized, message: nil), animated: true)
				return
			}
			parameters["address"] = address
		} else {
			
			// TEMPORARY
//			let dateFormatter = DateFormatter()
//			dateFormatter.dateFormat = "yyyy-MM-dd"
//
//			let birthDate = dateFormatter.string(from: detailsController.birthDatePicker.date)
			
			guard let birthDate = detailsController.birthDateTextField.text, birthDate != "" else {
				present(UIAlertController.simpleAlert(title: "birthDate_missing_title".localized, message: nil), animated: true)
				return
			}
			parameters["birthDate"] = birthDate
		}
		
		// Make the network call
		
		Network.register(with: parameters) { [weak self] data, response, _ in
			guard let response = response as? HTTPURLResponse,
				let data = data else { return }
			
			// Print the HTTP status code
			print("Status code:", response.statusCode)
			
			// Creating the JSON decoder
			let dateFormatter = DateFormatter()
			dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
			
			// If the register is a success
			if response.statusCode == 201 {
				// Decode JSON
				guard let unserializedJSON = try? JSONSerialization.jsonObject(with: data, options: []),
					let json = unserializedJSON as? [String: Int],
					let userId = json["id"] else { return }
				print(userId)
				
				guard let parameters = self?.parameters else { return }
				
				// Creating user info
				let user = User(id: userId,
								type: parameters["type"] as? Int ?? 0,
								mail: parameters["mail"] as? String ?? "",
								firstName: firstName,
								lastName: lastName,
								city: city,
								phoneNumber: phoneNumber)
				
				user.address = parameters["address"] as? String
				user.birthDate = dateFormatter.date(from: parameters["birthDate"] as? String ?? "")
				
				// Save user info
				Database().createOrUpdate(model: user, with: UserObject.init)
				UserDefaults.standard.set(user.userID, forKey: "userID")
				
				// Present the current controller for the user
				let tabBarController = user.type == 2 ? UITabBarController.coachController() : UITabBarController.clientController()
				
				DispatchQueue.main.async {
					self?.present(tabBarController, animated: true) {
						self?.navigationController?.popToRootViewController(animated: false)
					}
				}
			} else {
				let decoder = JSONDecoder()
				guard let errorMessage = try? decoder.decode(ErrorMessage.self, from: data) else { return }
				
				let alertController = UIAlertController.simpleAlert(title: "error".localized, message: errorMessage.message.localized)
				
				DispatchQueue.main.async {
					self?.present(alertController, animated: true)
				}
			}
		}
	}
}
