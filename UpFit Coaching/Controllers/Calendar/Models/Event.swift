//
//  Event.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 30/04/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
// Version 1.0

import Foundation
import RealmSwift

final class EventObject: Object {
	@objc dynamic var eventID = 0
	@objc dynamic var name = ""
	
	@objc dynamic var type = 0
	@objc dynamic var status = 0
	
	@objc dynamic var firstUser: UserObject!
	@objc dynamic var secondUser: UserObject!
	
	@objc dynamic var start = Date()
	@objc dynamic var end = Date()
	
	@objc dynamic var created = Date()
	@objc dynamic var createdBy: UserObject!
	
	@objc dynamic var updated = Date()
	@objc dynamic var updatedBy: UserObject!
	
	override static func primaryKey() -> String? {
		return "eventID"
	}
	
	convenience init(event: Event) {
		self.init()
		
		eventID = event.eventID ?? 0
		name = event.name
		
		type = event.type
		status = event.status
		
		firstUser = UserObject(user: event.firstUser)
		secondUser = UserObject(user: event.secondUser)
		
		start = event.start
		end = event.end
		
		created = event.created
		createdBy = UserObject(user: event.createdBy)
		
		updated = event.updated
		updatedBy = UserObject(user: event.updatedBy)
	}
}

class Event: NSObject, Codable {
	enum CodingKeys: String, CodingKey {
		case eventID = "id"
		case name
		
		case type
		case status
		
		case firstUser
		case secondUser
		
		case start
		case end
		
		case created
		case createdBy
		
		case updated
		case updatedBy
	}
	
	static let all = FetchRequest<[Event], EventObject>(predicate: nil, sortDescriptors: [], transformer: { $0.map(Event.init) })
	
	var eventID: Int?
	var name: String
	
	var type: Int
	var status: Int
	
	var firstUser: User
	var secondUser: User
	
	var start: Date
	var end: Date
	
	var created: Date
	var createdBy: User
	
	var updated: Date
	var updatedBy: User
	
	init(name: String, type: Int, firstUser: User, secondUser: User, start: Date, end: Date, createdBy: User, updatedBy: User) {
		self.name = name
		
		self.type = type
		self.status = 0
		
		self.firstUser = firstUser
		self.secondUser = secondUser
		
		self.start = start
		self.end = end
		
		self.created = Date()
		self.createdBy = createdBy
		
		self.updated = Date()
		self.updatedBy = updatedBy
	}
	
	init(object: EventObject) {
		eventID = object.eventID
		name = object.name
		
		type = object.type
		status = object.status
		
		firstUser = User(object: object.firstUser)
		secondUser = User(object: object.secondUser)
		
		start = object.start
		end = object.end
		
		created = object.created
		createdBy = User(object: object.createdBy)
		
		updated = object.updated
		updatedBy = User(object: object.updatedBy)
	}
	
	enum Address {
		case singleLine, twoLines
	}
	
	func address(_ mode: Address = .singleLine) -> String? {
		let separator = mode == .singleLine ? ", " : "\n"		
		
		if let userAddress = firstUser.address {
			return userAddress.appending(separator).appending(firstUser.city)
		}
		
		if let userAddress = secondUser.address {
			return userAddress.appending(separator).appending(secondUser.city)
		}
		
		return nil
	}
}
