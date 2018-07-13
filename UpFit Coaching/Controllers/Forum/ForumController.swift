//
//  ForumController.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 07/06/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit
import PKHUD

class ForumController: UIViewController {
	
	// MARK: - UI
	
	var tableView: UITableView!
	
	// MARK: - Data
	
	static var forumID = 1
	var forum: Forum?
	var threads = [ForumThread]()
	
	let dateFormatter = DateFormatter()
	
	// MARK: - UIViewController
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		threadsDownloaded()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Setup layout
		title = "forumController_title".localized
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addThread))
		setupLayout()
		
		// Setup dateformatter
		dateFormatter.dateStyle = .short
		dateFormatter.timeStyle = .short
		dateFormatter.doesRelativeDateFormatting = true
		
		// Register cell and notification
		tableView.register(ThreadCell.self, forCellReuseIdentifier: "ThreadCell")
		NotificationCenter.default.addObserver(self, selector: #selector(threadsDownloaded), name: .threadsDownloaded, object: nil)
	}
	
	// MARK: - Helpers
	
	func downloadThreads() {
		DispatchQueue.main.async {
			HUD.show(.progress)
		}
		
		Network.getThreads(for: ForumController.forumID) { data, response, _ in
			guard let data = data else { return }
			
			if Network.isSuccess(response: response, successCode: 200) {
				// Decode thread list
				let decoder = JSONDecoder.withDate
				guard let threads = try? decoder.decode([ForumThread].self, from: data) else { return }
				
				// Save threads
				let database = Database()
				database.deleteAll(of: ForumThreadObject.self)
				database.createOrUpdate(models: threads, with: ForumThreadObject.init)
				
				// Post a notification telling its done
				NotificationCenter.default.post(name: .threadsDownloaded, object: nil)
			} else {
				Network.displayError(self, from: data)
			}
			
			DispatchQueue.main.async {
				HUD.hide()
			}
		}
	}
	
	@objc func threadsDownloaded() {
		threads = Database().getThreads(for: ForumController.forumID).sorted { $0.lastUpdated > $1.lastUpdated }
		
		if let thread = threads.first {
			forum = thread.forum
		}
		
		DispatchQueue.main.async { [weak self] in
			self?.tableView.reloadData()
		}
	}
	
	@objc func addThread() {
		let createThreadController = CreateThreadController()
		createThreadController.forum = forum
		present(UINavigationController(rootViewController: createThreadController), animated: true)
	}
}
