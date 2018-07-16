//
//  CreateThreadController.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 07/06/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
// Version 1.0

import UIKit
import Eureka
import PKHUD

class CreateThreadController: FormViewController {
	
	let currentUser = Database().getCurrentUser()
	var forum: Forum?
	
	var titleRow: TextRow!
	var contentRow: TextAreaRow!
	
	var threadTitle: String!
	var postContent: String!
	
	// MARK: - UIViewController
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = "createThreadController_title".localized
		navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "addButton".localized, style: .done, target: self, action: #selector(add))
		
		threadTitle = ""
		postContent = ""
		
		setupLayout()
		toggleAddButton()
	}
	
	// MARK: - Actions
	
	@objc func add() {
		guard let currentUser = currentUser else { return }
		guard let forum = forum else { return }
		
		let thread = ForumThread(title: threadTitle, forum: forum)
		let post = Post(thread: thread, user: currentUser, date: Date(), content: postContent)
		thread.lastUser = post.user
		thread.lastUpdated = post.date

		DispatchQueue.main.async {
			HUD.show(.progress)
		}
		
		Network.createThread(thread, with: post) { [weak self] data, response, _ in
			guard let data = data else { return }

			if Network.isSuccess(response: response, successCode: 201) {
				// Unserialize thread and post id
				guard let unserializedData = self?.unserialize(data) else { return }

				// Set thread and post ids
				thread.threadID = unserializedData.threadId
				post.postID = unserializedData.postId

				// Save objects
				let database = Database()
				database.createOrUpdate(model: thread, with: ForumThreadObject.init)
				database.createOrUpdate(model: post, with: PostObject.init)

				// Dismiss controller
				self?.navigationController?.dismiss(animated: true)
			} else {
				Network.displayError(self, from: data)
			}
			
			DispatchQueue.main.async {
				HUD.hide()
			}
		}
	}
	
	@objc func cancel() {
		navigationController?.dismiss(animated: true)
	}
	
	// MARK: - Helpers
	
	func toggleAddButton() {
		navigationItem.rightBarButtonItem?.isEnabled = threadTitle != "" && postContent != ""
	}
	
	private func unserialize(_ data: Data) -> (postId: Int, threadId: Int)? {
		guard let unserializedJSON = try? JSONSerialization.jsonObject(with: data, options: []) else { return nil }
		guard let json = unserializedJSON as? [String: Int] else { return nil }
		
		guard let postId = json["postId"] else { return nil }
		guard let threadId = json["threadId"] else { return nil }
		
		return (postId: postId, threadId: threadId)
	}
}
