//
//  Conversation.swift
//  Coaching
//
//  Created by Jason Pierna on 10/03/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import Foundation
import RealmSwift

class Conversation: Object {
	@objc dynamic var name = ""
	@objc dynamic var message = ""

//	init(name: String, message: String) {
//		self.name = name
//		self.message = message
//	}
}
