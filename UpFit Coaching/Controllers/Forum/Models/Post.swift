//
//  Post.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 07/06/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import Foundation
import RealmSwift

final class PostObject: Object {
	@objc dynamic var postID = 0
	
	@objc dynamic var thread: ForumThreadObject!
	@objc dynamic var user: UserObject!
	
	@objc dynamic var date: Date!
	@objc dynamic var content = ""
	
	override static func primaryKey() -> String? {
		return "postID"
	}
	
	convenience init(post: Post) {
		self.init()
		
		postID = post.postID
		
		thread = ForumThreadObject(thread: post.thread)
		user = UserObject(user: post.user)
		
		date = post.date
		content = post.content
	}

}

class Post: NSObject, Codable {
	enum CodingKeys: String, CodingKey {
		case postID = "id"
		
		case thread
		case user
		
		case date
		case content
	}
	
	var postID: Int
	
	var thread: ForumThread
	var user: User
	
	var date: Date
	var content: String
	
	init(id: Int = 0, thread: ForumThread, user: User, date: Date, content: String) {
		postID = id
		self.thread = thread
		self.user = user
		self.date = date
		self.content = content
	}
	
	init(object: PostObject) {
		postID = object.postID
		
		thread = ForumThread(object: object.thread)
		user = User(object: object.user)
		
		date = object.date
		content = object.content
	}
}
