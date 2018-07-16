//
//  Forum.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 07/06/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
// Version 1.0

import Foundation
import RealmSwift

final class ForumObject: Object {
	@objc dynamic var forumID = 0
	@objc dynamic var name = ""
	
	override static func primaryKey() -> String? {
		return "forumID"
	}
	
	convenience init(forum: Forum) {
		self.init()
		
		forumID = forum.forumID
		name = forum.name
	}
}

class Forum: NSObject, Codable {
	enum CodingKeys: String, CodingKey {
		case forumID = "id"
		case name
	}
	
	var forumID: Int
	var name: String
	
	init(object: ForumObject) {
		forumID = object.forumID
		name = object.name
	}
}
