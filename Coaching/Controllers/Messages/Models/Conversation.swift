//
//  Conversation.swift
//  Coaching
//
//  Created by Jason Pierna on 10/03/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import Foundation

struct Conversation {
	let user: User
	let message: Message
	
	static func generateConversations(from messages: [Message], for currentUser: User) -> [Conversation] {
		var conversations = [Conversation]()
		
		// Get users from messages
		let users = messages.map { $0.receiver == currentUser ? $0.sender : $0.receiver }
		
		// Get unique list of users
		var uniqueUsers = [User]()
		for user in users {
			if !uniqueUsers.contains(user) {
				uniqueUsers.append(user)
			}
		}
		
		// Get last message for each user
		for user in uniqueUsers {
			guard let lastMessage = messages.filter({ $0.receiver == user || $0.sender == user }).sorted(by: { $0.date < $1.date }).last else { continue }
			conversations.append(Conversation(user: user, message: lastMessage))
		}
				
		// Sort conversations by date, descending
		return conversations.sorted(by: { $0.message.date > $1.message.date})
	}
}
