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
	var typeController: TypeRegisterController!
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
		
		Network.register(with: registerBox.parameters) { [weak self] data, response, _ in
			guard let data = data else { return }
			
			if Network.isSuccess(response: response, successCode: 201) {
				guard let userId = self?.unserialize(data) else { return }
				print(userId)
				
				guard let registerBox = self?.registerBox else { return }
				
				// Creating user info
				let user = User(id: userId, type: registerBox.type, mail: registerBox.mail,
								firstName: registerBox.firstName, lastName: registerBox.lastName,
								city: registerBox.city, phoneNumber: registerBox.phoneNumber)
				
				user.address = registerBox.address
				
				if let birthDate = registerBox.birthDate {
					let dateFormatter = DateFormatter()
					dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
					
					user.birthDate = dateFormatter.date(from: birthDate)
				}
				
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
	
	private func unserialize(_ data: Data) -> Int? {
		guard let unserializedJSON = try? JSONSerialization.jsonObject(with: data, options: []) else { return nil }
		guard let json = unserializedJSON as? [String: Int] else { return nil }
		guard let userId = json["id"] else { return nil }
		
		return userId
	}
}
