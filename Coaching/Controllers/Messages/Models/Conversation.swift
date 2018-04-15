//
//  Conversation.swift
//  Coaching
//
//  Created by Jason Pierna on 10/03/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import Foundation
import RealmSwift

final class ConversationObject: Object {

	@objc dynamic var conversationID = UUID().uuidString
	@objc dynamic var name = ""
	@objc dynamic var message = ""
	
	convenience init(conversation: Conversation) {
		self.init()
		
		conversationID = conversation.conversationID
		name = conversation.name
		message = conversation.message
	}

	override static func primaryKey() -> String? {
		return "conversationID"
	}
}

struct Conversation {
	let conversationID: String
	let name: String
	let message: String
	
	static let all = FetchRequest<[Conversation], ConversationObject>(predicate: nil, sortDescriptors: [], transformer: { $0.map(Conversation.init) })
}

extension Conversation {
	init(object: ConversationObject) {
		conversationID = object.conversationID
		name = object.name
		message = object.message
	}
}
