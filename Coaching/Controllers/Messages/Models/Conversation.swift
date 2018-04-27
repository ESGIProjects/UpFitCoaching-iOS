//
//  Conversation.swift
//  Coaching
//
//  Created by Jason Pierna on 10/03/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import Foundation

struct Conversation {
	var user: User
	var message: Message
	
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
		return conversations.sorted(by: { $0.message.date > $1.message.date })
	}
}

extension Array where Iterator.Element == Conversation {
	mutating func add(message: Message) {
		if let index = index(where: { $0.user == message.sender }) {
			self[index].message = message
			self = sorted(by: { $0.message.date > $1.message.date })
		} else {
			insert(Conversation(user: message.sender, message: message), at: 0)
		}
	}
}
