//
//  SettingsController.swift
//  Coaching
//
//  Created by Jason Pierna on 10/04/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit

class SettingsController: UIViewController {
	
	// MARK: - UI
	
	var tableView: UITableView!
	
	// MARK: - UIViewController
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Layout
		title = "settings_title".localized
		
		tableView = UITableView(frame: .zero, style: .grouped)
		tableView.translatesAutoresizingMaskIntoConstraints = false
		tableView.dataSource = self
		tableView.delegate = self
		
		view.addSubview(tableView)
		
		if #available(iOS 11.0, *) {
			NSLayoutConstraint.activate([
				tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
				tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
				tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
				tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
				])
		} else {
			NSLayoutConstraint.activate([
				tableView.topAnchor.constraint(equalTo: view.topAnchor),
				tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
				tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
				tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
				])
		}
	}
	
	// MARK: - Actions
	
	@objc func signOut(_ sender: UIButton) {
		
		let database = Database()
		
		if let user = database.getCurrentUser() {
			database.delete(type: UserObject.self, with: user.userID)
			UserDefaults.standard.removeObject(forKey: "userID")
			
			if tabBarController?.presentingViewController != nil {
				tabBarController?.dismiss(animated: true)
			} else {
				guard let window = (UIApplication.shared.delegate as? AppDelegate)?.window else { return }
				window.rootViewController = UINavigationController(rootViewController: LoginController())
			}
		}
	}
}

// MARK: - UITableViewDataSource
extension SettingsController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let button = UIButton()
		button.translatesAutoresizingMaskIntoConstraints = false
		
		button.setTitle("signOut_button".localized, for: .normal)
		button.setTitleColor(.red, for: .normal)
		button.addTarget(self, action: #selector(signOut(_:)), for: .touchUpInside)
		
		let cell = UITableViewCell()
		cell.contentView.addSubview(button)
		
		NSLayoutConstraint.activate([
			button.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
			button.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor),
			button.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor),
			button.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor)
			])
		
		return cell
	}
}

// MARK: - UITableViewDelegate
extension SettingsController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}
}
