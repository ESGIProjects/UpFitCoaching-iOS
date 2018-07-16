//
//  ForumThread.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 07/06/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
// Version 1.0

import Foundation
import RealmSwift

final class ForumThreadObject: Object {
	@objc dynamic var threadID = 0
	@objc dynamic var title = ""
	@objc dynamic var forum: ForumObject!
	
	@objc dynamic var lastUpdated: Date!
	@objc dynamic var lastUser: UserObject!
	
	override static func primaryKey() -> String? {
		return "threadID"
	}
	
	convenience init(thread: ForumThread) {
		self.init()
		
		threadID = thread.threadID
		title = thread.title
		forum = ForumObject(forum: thread.forum)
		
		lastUpdated = thread.lastUpdated
		lastUser = UserObject(user: thread.lastUser)
	}
}

class ForumThread: NSObject, Codable {
	enum CodingKeys: String, CodingKey {
		case threadID = "id"
		case title
		case forum
		
		case lastUpdated
		case lastUser
	}
	
	var threadID: Int
	var title: String
	var forum: Forum
	
	var lastUpdated: Date!
	var lastUser: User!
	
	init(id: Int = 0, title: String, forum: Forum) {
		threadID = id
		self.title = title
		self.forum = forum
	}
	
	init(object: ForumThreadObject) {
		threadID = object.threadID
		title = object.title
		forum = Forum(object: object.forum)
		
		lastUpdated = object.lastUpdated
		lastUser = User(object: object.lastUser)
	}
}
