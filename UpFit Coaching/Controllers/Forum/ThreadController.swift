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
		
		// Register cell and notification
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "PostCell")
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
			}
			
			DispatchQueue.main.async {
				HUD.hide()
			}
		}
	}
	
	@objc func addPost() {
		guard let currentUser = currentUser else { return }
		guard let thread = thread else { return }
		
		let alertController = UIAlertController(title: "addPostController_title".localized, message: nil, preferredStyle: .alert)
		alertController.addTextField { textField in
			textField.placeholder = "postContent_placeholder".localized
		}
		
		alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
		alertController.addAction(UIAlertAction(title: "OKButton".localized, style: .default, handler: { _ in
			guard let textField = alertController.textFields?[0],
			let postContent = textField.text, postContent != "" else { return }
			
			let post = Post(thread: thread, user: currentUser, date: Date(), content: postContent)
			
			Network.addPost(post, to: thread) { [weak self] data, response, _ in
				guard let data = data else { return }
				
				if Network.isSuccess(response: response, successCode: 201) {
					// Unserialize post id
					guard let postID = self?.unserialize(data) else { return }
					
					// Set post id
					post.postID = postID
					
					// Save object
					Database().createOrUpdate(model: post, with: PostObject.init)
					
					// Reload posts
					self?.postsDownloaded()
				}
			}
		}))
		
		present(alertController, animated: true)
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

extension ThreadController {
	class UI {
		class func tableView() -> UITableView {
			let view = UITableView(frame: .zero)
			view.translatesAutoresizingMaskIntoConstraints = false
			
			return view
		}
	}
	
	fileprivate func getConstraints() -> [NSLayoutConstraint] {
		let anchors = getAnchors()
		
		return [
			tableView.topAnchor.constraint(equalTo: anchors.top),
			tableView.bottomAnchor.constraint(equalTo: anchors.bottom),
			tableView.leadingAnchor.constraint(equalTo: anchors.leading),
			tableView.trailingAnchor.constraint(equalTo: anchors.trailing)
		]
	}
	
	fileprivate func setUIComponents() {
		tableView = UI.tableView()
		tableView.dataSource = self
	}
	
	func setupLayout() {
		setUIComponents()
		
		view.addSubview(tableView)
		NSLayoutConstraint.activate(getConstraints())
	}
}

extension ThreadController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return posts.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath)
		
		let post = posts[indexPath.row]
		cell.textLabel?.text = post.content
		
		return cell
	}
}
