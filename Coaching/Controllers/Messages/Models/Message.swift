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
	@objc dynamic var sender = 0
	@objc dynamic var receiver = 0
	@objc dynamic var date = Date()
	@objc dynamic var content = ""
	
	override static func primaryKey() -> String? {
		return "messageID"
	}
	
	convenience init(message: Message) {
		self.init()
		
		messageID = message.messageID ?? 0
		sender = message.sender
		receiver = message.receiver
		date = message.date
		content = message.content
	}
}

struct Message: Codable {
	enum CodingKeys: String, CodingKey {
		case messageID = "id"
		case sender
		case receiver
		case date
		case content
	}
	
	static let all = FetchRequest<[Message], MessageObject>(predicate: nil, sortDescriptors: [], transformer: { $0.map(Message.init) })
	
	var messageID: Int?
	let sender: Int
	let receiver: Int
	let date: Date
	let content: String
}

extension Message {
	init(object: MessageObject) {
		messageID = object.messageID
		sender = object.sender
		receiver = object.receiver
		date = object.date
		content = object.content
	}
}
