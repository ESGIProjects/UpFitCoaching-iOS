//
//  Message.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 11/03/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import Foundation
import RealmSwift

final class MessageObject: Object {
	@objc dynamic var messageID = 0
	
	@objc dynamic var sender: UserObject!
	@objc dynamic var receiver: UserObject!
	
	@objc dynamic var date = Date()
	@objc dynamic var content = ""
	
	override static func primaryKey() -> String? {
		return "messageID"
	}
	
	convenience init(message: Message) {
		self.init()
		
		messageID = message.messageID ?? 0
		
		sender = UserObject(user: message.sender)
		receiver = UserObject(user: message.receiver)
		
		date = message.date
		content = message.content
	}
}

class Message: NSObject, Codable {
	enum CodingKeys: String, CodingKey {
		case messageID = "id"
		
		case sender
		case receiver
		
		case date
		case content
	}
	
	static let all = FetchRequest<[Message], MessageObject>(predicate: nil, sortDescriptors: [], transformer: { $0.map(Message.init) })
	
	var messageID: Int?
	
	let sender: User
	let receiver: User
	
	let date: Date
	let content: String
	
	init(sender: User, receiver: User, date: Date, content: String) {
		self.sender = sender
		self.receiver = receiver
		
		self.date = date
		self.content = content
	}
	
	init(object: MessageObject) {
		messageID = object.messageID
		
		sender = User(object: object.sender)
		receiver = User(object: object.receiver)
		
		date = object.date
		content = object.content
	}
}
