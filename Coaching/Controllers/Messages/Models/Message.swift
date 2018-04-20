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
	@objc dynamic var messageID = 0
	@objc dynamic var senderID = 0
	@objc dynamic var senderType = 0
	@objc dynamic var receiverID = 0
	@objc dynamic var receiverType = 0
	@objc dynamic var date = Date()
	@objc dynamic var content = ""
	
	override static func primaryKey() -> String? {
		return "messageID"
	}
	
	convenience init(message: Message) {
		self.init()
		
		messageID = message.messageID ?? 0
		senderID = message.senderID
		senderType = message.senderType
		receiverID = message.receiverID
		receiverType = message.receiverType
		date = message.date
		content = message.content
	}
}

struct Message: Codable {
	enum CodingKeys: String, CodingKey {
		case messageID = "id"
		case senderID = "fromId"
		case senderType = "fromType"
		case receiverID = "toId"
		case receiverType = "toType"
		case date
		case content
	}
	
	let messageID: Int?
	let senderID: Int
	let senderType: Int
	let receiverID: Int
	let receiverType: Int
	let date: Date
	let content: String
}

extension Message {
	init(object: MessageObject) {
		messageID = object.messageID
		senderID = object.senderID
		senderType = object.senderType
		receiverID = object.receiverID
		receiverType = object.receiverType
		date = object.date
		content = object.content
	}
}
