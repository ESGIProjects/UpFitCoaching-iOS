//
//  ForumThread.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 07/06/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import Foundation
import RealmSwift

final class ForumThreadObject: Object {
	@objc dynamic var threadID = 0
	@objc dynamic var title = ""
	@objc dynamic var forum: ForumObject!
	
	override static func primaryKey() -> String? {
		return "threadID"
	}
	
	convenience init(thread: ForumThread) {
		self.init()
		
		threadID = thread.threadID
		title = thread.title
		forum = ForumObject(forum: thread.forum)
	}
}

class ForumThread: NSObject, Codable {
	enum CodingKeys: String, CodingKey {
		case threadID = "id"
		case title
		case forum
	}
	
	var threadID: Int
	var title: String
	var forum: Forum
	
	init(id: Int = 0, title: String, forum: Forum) {
		threadID = id
		self.title = title
		self.forum = forum
	}
	
	init(object: ForumThreadObject) {
		threadID = object.threadID
		title = object.title
		forum = Forum(object: object.forum)
	}
}
