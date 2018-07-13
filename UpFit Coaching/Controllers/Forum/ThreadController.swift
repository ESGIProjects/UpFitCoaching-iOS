//
//  ThreadController.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 08/06/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit
import PKHUD

class ThreadController: UIViewController {
	
	// MARK: - UI
	
	var tableView: UITableView!
	
	// MARK: - Data
	
	var currentUser = Database().getCurrentUser()
	var thread: ForumThread?
	var posts = [Post]()
	
	let dateFormatter = DateFormatter()
	
	// MARK: - UIViewController
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		postsDownloaded()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Setup layout
		title = thread?.title
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPost))
		setupLayout()
		
		// Setup formatter
		dateFormatter.timeStyle = .short
		dateFormatter.dateStyle = .short
		dateFormatter.doesRelativeDateFormatting = true
		
		// Register cell and notification
		tableView.register(PostCell.self, forCellReuseIdentifier: "PostCell")
		NotificationCenter.default.addObserver(self, selector: #selector(postsDownloaded), name: .postsDownloaded, object: nil)
		
		// Download all posts
		downloadPosts()
	}
	
	// MARK: - Helpers
	
	func downloadPosts() {
		guard let thread = thread else { return }
		
		DispatchQueue.main.async {
			HUD.show(.progress)
		}
		
		Network.getPosts(for: thread) { data, response, _ in
			guard let data = data else { return }
			
			if Network.isSuccess(response: response, successCode: 200) {
				// Decode post list
				let decoder = JSONDecoder.withDate
				guard let posts = try? decoder.decode([Post].self, from: data) else { return }
				
				// Save posts
				let database = Database()
				database.deleteAll(of: PostObject.self)
				database.createOrUpdate(models: posts, with: PostObject.init)
				
				// Post a notification telling its done
				NotificationCenter.default.post(name: .postsDownloaded, object: nil)
			} else {
				Network.displayError(self, from: data)
			}
			
			DispatchQueue.main.async {
				HUD.hide()
			}
		}
	}
	
	@objc func addPost() {
		let addPostController = AddPostController()
		addPostController.thread = thread
		present(UINavigationController(rootViewController: addPostController), animated: true)
	}
	
	private func unserialize(_ data: Data) -> Int? {
		guard let unserializedJSON = try? JSONSerialization.jsonObject(with: data, options: []) else { return nil }
		guard let json = unserializedJSON as? [String: Int] else { return nil }
		
		guard let postId = json["postId"] else { return nil }
		
		return postId
	}
	
	@objc func postsDownloaded() {
		guard let thread = thread else { return }
		
		posts = Database().getPosts(for: thread)
		
		DispatchQueue.main.async { [weak self] in
			self?.tableView.reloadData()
		}
	}
}
