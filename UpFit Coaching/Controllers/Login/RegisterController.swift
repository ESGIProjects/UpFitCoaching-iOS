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
	
	var pageViewController: UIPageViewController!
//	var typeController: TypeRegisterController!
	var accountController: AccountRegisterController!
	var detailsController: DetailsRegisterController!
	
	// MARK: - Data
	
	var type: Int?
	var registerBox = RegisterBox()
	
	// MARK: - UIViewController
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Layout
		title = "signUpController_title".localized
		view.backgroundColor = .white
		setupLayout()
		
		type = 0
	}
	
	override func viewWillAppear(_ animated: Bool) {
		navigationController?.setNavigationBarHidden(false, animated: true)
	}
	
	// MARK: - Actions
	
	func goToAccount(_ direction: UIPageViewControllerNavigationDirection) {
		pageViewController.setViewControllers([accountController], direction: direction, animated: true)
		detailsController.type = registerBox.type
	}
	
	func goToDetails(_ direction: UIPageViewControllerNavigationDirection) {
		pageViewController.setViewControllers([detailsController], direction: direction, animated: true)
	}
	
	@objc func register() {
		// Once every field is checked, we make the API call
		
		var parameters = registerBox.parameters
		
		// Hash the password
		if let password = parameters["password"] as? String {
			parameters["password"] = password.sha256()
		}
		
		// Parse birth date
		if let birthDate = parameters["birthDate"] {
			parameters["birthDate"] = DateFormatter.date.string(for: birthDate)
		}
		
		Network.register(with: parameters) { [weak self] data, response, _ in
			guard let data = data else { return }
			
			if Network.isSuccess(response: response, successCode: 201) {
				let unserializedData = self?.unserialize(data)
				
				guard let userId = unserializedData?.0 else { return }
				guard let registerBox = self?.registerBox else { return }
				
				// Creating user info
				let user = User(id: userId, type: registerBox.type, mail: registerBox.mail,
								firstName: registerBox.firstName, lastName: registerBox.lastName,
								city: registerBox.city, phoneNumber: registerBox.phoneNumber)
				
				user.address = registerBox.address
				user.birthDate = registerBox.birthDate
				user.coach = unserializedData?.1
				
				// Save user info
				Database().createOrUpdate(model: user, with: UserObject.init)
				UserDefaults.standard.set(user.userID, forKey: "userID")
				
				// Present the current controller for the user
				let tabBarController = UITabBarController.getRootViewController(for: user)
				
				// Start socket
				MessagesDelegate.instance.connect()
				
				DispatchQueue.main.async {
					self?.present(tabBarController, animated: true) {
						self?.navigationController?.popToRootViewController(animated: false)
					}
				}
			} else {
				Network.displayError(self, from: data)
			}
		}
	}
	
	private func unserialize(_ data: Data) -> (Int?, User?) {
		guard let unserializedJSON = try? JSONSerialization.jsonObject(with: data, options: []) else { return (nil, nil) }
		guard let json = unserializedJSON as? [String: Any] else { return (nil, nil) }
		guard let userId = json["id"] as? Int else { return (nil, nil) }
		
		if let coachJson = json["coach"] as? [String: Any] {
			print(coachJson)
			return (userId, User(json: coachJson))
		}
		
		return (userId, nil)
	}
}
