//
//  Message.swift
//  Coaching
//
//  Created by Jason Pierna on 11/03/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import Foundation
import RealmSwift

final class MessageObject: Object {
	@objc dynamic var messageID = UUID().uuidString
	@objc dynamic var sender = ""
	@objc dynamic var receiver = ""
	@objc dynamic var content = ""
	@objc dynamic var date = Date()
	
	override static func primaryKey() -> String? {
		return "messageID"
	}
	
	convenience init(message: Message) {
		self.init()
		
		messageID = message.messageID
		sender = message.sender
		receiver = message.receiver
		content = message.content
		date = message.date
	}
}

struct Message {
	let messageID: String
	let sender: String
	let receiver: String
	let content: String
	let date: Date
}

extension Message {
	init(object: MessageObject) {
		messageID = object.messageID
		sender = object.sender
		receiver = object.receiver
		content = object.content
		date = object.date
	}
}
