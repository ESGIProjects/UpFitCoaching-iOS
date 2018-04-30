//
//  Event.swift
//  Coaching
//
//  Created by Jason Pierna on 30/04/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import Foundation
import RealmSwift

final class EventObject: Object {
	@objc dynamic var eventID = 0
	@objc dynamic var name = ""
	@objc dynamic var client: UserObject!
	@objc dynamic var coach: UserObject!
	@objc dynamic var start = Date()
	@objc dynamic var end = Date()
	@objc dynamic var created = Date()
	@objc dynamic var updated = Date()
	
	override static func primaryKey() -> String? {
		return "eventID"
	}
	
	convenience init(event: Event) {
		self.init()
		
		eventID = event.eventID ?? 0
		name = event.name
		client = UserObject(user: event.client)
		coach = UserObject(user: event.coach)
		start = event.start
		end = event.end
		created = event.created
		updated = event.updated
	}
}

struct Event: Codable {
	enum CodingKeys: String, CodingKey {
		case eventID = "id"
		case name
		case client
		case coach
		case start
		case end
		case created
		case updated
	}
	
	static let all = FetchRequest<[Event], EventObject>(predicate: nil, sortDescriptors: [], transformer: { $0.map(Event.init) })
	
	var eventID: Int?
	var name: String
	var client: User
	var coach: User
	var start: Date
	var end: Date
	var created: Date
	var updated: Date
}

extension Event {
	init(object: EventObject) {
		eventID = object.eventID
		name = object.name
		client = User(object: object.client)
		coach = User(object: object.coach)
		start = object.start
		end = object.end
		created = object.created
		updated = object.updated
	}
}
