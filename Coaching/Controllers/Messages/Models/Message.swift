//
//  Message.swift
//  Coaching
//
//  Created by Jason Pierna on 11/03/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import Foundation

class Message {
	var sender: String
	var receiver: String
	var content: String
	var date: Date
	
	init(_ content: String, from sender: String, to receiver: String, at date: Date) {
		self.sender = sender
		self.receiver = receiver
		self.content = content
		self.date = date
	}
}
