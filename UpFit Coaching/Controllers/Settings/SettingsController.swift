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
	
	lazy var tableView = UI.tableView(delegate: self, dataSource: self)
	lazy var signOutButton = UI.signOutButton(self, action: #selector(signOut(_:)))
	
	// MARK: - UIViewController
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Layout
		title = "settings_title".localized
		setupLayout()
	}
	
	private func setupLayout() {
		view.addSubview(tableView)
		NSLayoutConstraint.activate(getConstraints(for: self))
	}
	
	// MARK: - Actions
	
	@objc func signOut(_ sender: UIButton) {
		Database().deleteAll()
		UserDefaults.standard.removeObject(forKey: "userID")
		
		if tabBarController?.presentingViewController != nil {
			tabBarController?.dismiss(animated: true)
		} else {
			guard let window = (UIApplication.shared.delegate as? AppDelegate)?.window else { return }
			window.rootViewController = UINavigationController(rootViewController: LoginController())
		}
	}
}

// MARK: - UITableViewDataSource
extension SettingsController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = UITableViewCell()
		cell.contentView.addSubview(signOutButton)
		
		NSLayoutConstraint.activate([
			signOutButton.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
			signOutButton.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor),
			signOutButton.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor),
			signOutButton.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor)
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
