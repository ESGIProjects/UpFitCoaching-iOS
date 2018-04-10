//
//  SettingsController.swift
//  Coaching
//
//  Created by Jason Pierna on 10/04/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit

class SettingsController: UIViewController {
	var tableView: UITableView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = "Settings"
		
		tableView = UITableView(frame: .zero, style: .grouped)
		tableView.dataSource = self
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SettingsCell")
		
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
}

extension SettingsController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell") else { return UITableViewCell(style: .default, reuseIdentifier: "SettingsCell") }
		
		cell.textLabel?.text = "Hello world"
		
		return cell
	}
}
