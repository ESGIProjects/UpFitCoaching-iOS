//
//  ConversationListController.swift
//  Coaching
//
//  Created by Jason Pierna on 20/02/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit

class ConversationListController: UIViewController {
	
	lazy var tableView: UITableView = {
		let tableView = UITableView(frame: .zero)
		tableView.translatesAutoresizingMaskIntoConstraints = false
		tableView.delegate = self
		tableView.dataSource = self
		return tableView
	}()
	
	var conversations: [(name: String, message: String, date: Date)] = [
		(name: "Jason Pierna", message: "Ceci est un messageCeci est un messageCeci est un messageCeci est un messageCeci est un messageCeci est un messageCeci est un messageCeci est un messageCeci est un messageCeci est un messageCeci est un messageCeci est un message", date: Date()),
		(name: "Kévin Le", message: "Ceci est un deuxième message 🐷", date: Date()),
		(name: "Maeva Malih", message: "Coucou", date: Date())
	]
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = "Messages"
		tableView.estimatedRowHeight = 100.0
		tableView.rowHeight = UITableViewAutomaticDimension
		tableView.register(ConversationListCell.self, forCellReuseIdentifier: "ConversationListCell")
		
		setupLayout()
	}
	
	private func setupLayout() {
		// Layout the table view
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

extension ConversationListController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return conversations.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell: ConversationListCell!
		
		if let dequeueCell = tableView.dequeueReusableCell(withIdentifier: "ConversationListCell", for: indexPath) as? ConversationListCell {
			cell = dequeueCell
		} else {
			cell = ConversationListCell(frame: .zero)
		}
		
		cell.accessoryType = .disclosureIndicator
		
		cell.nameLabel.text = conversations[indexPath.row].name
		cell.messageLabel.text = conversations[indexPath.row].message
		
		return cell
	}
}

extension ConversationListController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		
		let conversationViewController = ConversationViewController()
		conversationViewController.title = conversations[indexPath.row].name

		navigationController?.pushViewController(conversationViewController, animated: true)
	}
}
