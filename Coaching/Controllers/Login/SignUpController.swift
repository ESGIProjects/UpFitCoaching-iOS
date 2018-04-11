//
//  SignUpController.swift
//  Coaching
//
//  Created by Jason Pierna on 11/04/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit

class SignUpController: UIViewController {
	
	lazy var scrollView = UI.scrollView()
	lazy var contentView = UI.contentView()
	lazy var firstNameTextField = UI.firstNameTextField()
	lazy var lastNameTextField = UI.lastNameTextField()
	lazy var mailTextField = UI.mailTextField()
	lazy var passwordTextField = UI.passwordTextField()
	lazy var confirmPasswordTextField = UI.confirmPasswordTextField()
	lazy var signUpButton = UI.signUpButton(self, action: #selector(signUp(_:)))
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = "signupController_title".localized
		view.backgroundColor = .white
		setupLayout()		
	}
	
	override func viewWillAppear(_ animated: Bool) {
		navigationController?.setNavigationBarHidden(false, animated: true)
	}
	
	private func setupLayout() {
		view.addSubview(scrollView)
		scrollView.addSubview(contentView)
		
		contentView.addSubview(firstNameTextField)
		contentView.addSubview(lastNameTextField)
		contentView.addSubview(mailTextField)
		contentView.addSubview(passwordTextField)
		contentView.addSubview(confirmPasswordTextField)
		contentView.addSubview(signUpButton)
		
		let constraints = UI.getConstraints(for: self)
		NSLayoutConstraint.activate(constraints)
	}
	
	@objc func signUp(_ sender: UIButton) {
		
	}
}
