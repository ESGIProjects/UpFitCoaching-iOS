//
//  AddPostController.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 11/06/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit
import Eureka
import PKHUD

class AddPostController: FormViewController {
	
	let currentUser = Database().getCurrentUser()
	var thread: ForumThread?
	
	var contentRow: TextAreaRow!
	var postContent: String!
	
	// MARK: - UIViewController
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = "addPostController_title".localized
		navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "addButton".localized, style: .done, target: self, action: #selector(add))
		
		postContent = ""
		
		setupLayout()
		toggleAddButton()
	}
	
	// MARK: - Actions
	
	@objc func add() {
		guard let currentUser = currentUser else { return }
		guard let thread = thread else { return }
		
		let post = Post(thread: thread, user: currentUser, date: Date(), content: postContent)
		
		DispatchQueue.main.async {
			HUD.show(.progress)
		}
		
		Network.addPost(post, to: thread) { [weak self] data, response, _ in
			guard let data = data else { return }
			
			if Network.isSuccess(response: response, successCode: 201) {
				// Unserialize post id
				guard let postID = self?.unserialize(data) else { return }
				
				// Set post id
				post.postID = postID
				
				// Save object
				Database().createOrUpdate(model: post, with: PostObject.init)
				
				// Dismiss controller
				self?.navigationController?.dismiss(animated: true)
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
		navigationItem.rightBarButtonItem?.isEnabled = postContent != ""
	}
	
	private func unserialize(_ data: Data) -> Int? {
		guard let unserializedJSON = try? JSONSerialization.jsonObject(with: data, options: []) else { return nil }
		guard let json = unserializedJSON as? [String: Int] else { return nil }
		
		guard let postId = json["postId"] else { return nil }
		
		return postId
	}
}
