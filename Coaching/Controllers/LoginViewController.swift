//
//  LoginViewController.swift
//  Coaching
//
//  Created by Jason Pierna on 20/02/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
	lazy var stackView: UIStackView = {
		let stackView = UIStackView()
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.axis = .vertical
		return stackView
	}()
	
	lazy var mailTextField: UITextField = {
		let mailTextField = UITextField(frame: .zero)
		mailTextField.translatesAutoresizingMaskIntoConstraints = false
		mailTextField.borderStyle = .roundedRect
		mailTextField.keyboardType = .emailAddress
		mailTextField.returnKeyType = .next
		mailTextField.placeholder = "Mail"
		return mailTextField
	}()
	
	lazy var passwordTextField: UITextField = {
		let passwordTextField = UITextField(frame: .zero)
		passwordTextField.translatesAutoresizingMaskIntoConstraints = false
		passwordTextField.borderStyle = .roundedRect
		passwordTextField.isSecureTextEntry = true
		passwordTextField.returnKeyType = .done
		passwordTextField.placeholder = "Password"
		return passwordTextField
	}()
	
	lazy var loginButton: UIButton = {
		let loginButton = UIButton()
		loginButton.translatesAutoresizingMaskIntoConstraints = false
		loginButton.setTitle("Sign In", for: .normal)
		loginButton.setTitleColor(.red, for: .normal)
		loginButton.addTarget(self, action: #selector(signin(_:)), for: .touchUpInside)
		return loginButton
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupLayout()
	}
	
	func setupLayout() {
		// Text fields
		stackView.addArrangedSubview(mailTextField)
		stackView.addArrangedSubview(passwordTextField)
		stackView.addArrangedSubview(loginButton)
		
		// Layout the stack view
		view.addSubview(stackView)
		
		NSLayoutConstraint.activate([
			stackView.topAnchor.constraint(equalTo: view.topAnchor),
			stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			stackView.heightAnchor.constraint(equalToConstant: 300)
			])
		
		
	}
	
	@objc func signin(_ sender: UIButton) {
		if mailTextField.text == "" {
			let alert = UIAlertController(title: "Mail missing", message: nil, preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "OK", style: .default))
			present(alert, animated: true)
			return
		}
		
		if passwordTextField.text == "" {
			let alert = UIAlertController(title: "Password missing", message: nil, preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "OK", style: .default))
			present(alert, animated: true)
			return
		}
		
		print("-------------- LOGIN NETWORK CALL HERE")
		var request = URLRequest(url: URL(string: "http://localhost:8000/signin/")!)
//		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//		request.addValue("application/json", forHTTPHeaderField: "Accept")
		request.httpMethod = "POST"
		
		let postParams = "mail=\(mailTextField.text!)&passwd=\(passwordTextField.text!)"
		request.httpBody = postParams.data(using: .utf8)
		
		let session = URLSession(configuration: .default)
		session.dataTask(with: request) { (data, response, error) in
			print(data ?? "No data")
			print(response ?? "no response")
			print(error ?? "no error")
		}.resume()
		
		
		
	}
}
