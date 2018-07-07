//
//  RegisterController.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 06/05/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit
import CryptoSwift
import PKHUD

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
		
		DispatchQueue.main.async {
			HUD.show(.progress)
		}
		
		Network.register(with: parameters) { [weak self] data, response, _ in
			guard let data = data else { return }
			
			if Network.isSuccess(response: response, successCode: 201) {
				let unserializedData = self?.unserialize(data)
				
				guard let userId = unserializedData?.id else { return }
				guard let token = unserializedData?.token else { return }
				guard let registerBox = self?.registerBox else { return }
				
				// Creating user info
				let user = User(id: userId, type: registerBox.type, mail: registerBox.mail,
								firstName: registerBox.firstName, lastName: registerBox.lastName,
								city: registerBox.city, phoneNumber: registerBox.phoneNumber)
				
				user.address = registerBox.address
				user.birthDate = registerBox.birthDate
				user.coach = unserializedData?.coach
				
				UserDefaults.standard.set(token, forKey: "authToken")
				
				self?.processLogin(for: user) {
					self?.navigationController?.popToRootViewController(animated: false)
				}
			} else {
				Network.displayError(self, from: data)
			}
			
			DispatchQueue.main.async {
				HUD.hide()
			}
		}
	}
	
	private func unserialize(_ data: Data) -> (id: Int?, token: String?, coach: User?) {
		guard let unserializedJSON = try? JSONSerialization.jsonObject(with: data, options: []) else { return (nil, nil, nil) }
		guard let json = unserializedJSON as? [String: Any] else { return (nil, nil, nil) }
		guard let userId = json["id"] as? Int else { return (nil, nil, nil) }
		guard let token = json["token"] as? String else { return (nil, nil, nil) }
		
		if let coachJson = json["coach"] as? [String: Any] {
			return (userId, token, User(json: coachJson))
		}
		
		return (userId, token, nil)
	}
}
