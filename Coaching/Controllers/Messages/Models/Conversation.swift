//
//  Conversation.swift
//  Coaching
//
//  Created by Jason Pierna on 10/03/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import Foundation

struct Conversation {
	let user: Int
	let message: Message
	
	static func generateConversations(from messages: [Message], for currentUser: User) -> [Conversation] {
		var conversations = [Conversation]()
		
		// Get users from messages
		var users = messages.map { $0.receiver == currentUser.userID ? $0.sender : $0.receiver }
		users = Array(Set(users))
		
		// Get last message for each user
		for user in users {
			guard let lastMessage = messages.filter({ $0.receiver == user || $0.sender == user }).sorted(by: { $0.date < $1.date }).last else { continue }
			conversations.append(Conversation(user: user, message: lastMessage))
		}
				
		// Sort conversations by date, descending
		return conversations.sorted(by: { $0.message.date > $1.message.date })
	}
}
