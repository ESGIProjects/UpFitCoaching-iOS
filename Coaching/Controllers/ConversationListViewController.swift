//
//  ConversationListViewController.swift
//  Coaching
//
//  Created by Jason Pierna on 19/02/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit

class ConversationListViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
		
		tableView.register(ConversationTableViewCell.self, forCellReuseIdentifier: "ConversationCell")
    }
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 10
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "ConversationCell", for: indexPath) as? ConversationTableViewCell else {
			print("error dequeue")
			return ConversationTableViewCell()
		}
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		
		let conversationViewController = ConversationViewController()
		navigationController?.pushViewController(conversationViewController, animated: true)
	}
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 60
	}
}
