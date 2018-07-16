//
//  Test.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 22/06/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
// Version 1.0

import Foundation
import RealmSwift

final class TestObject: Object {
	@objc dynamic var testID = 0
	@objc dynamic var user: UserObject!
	@objc dynamic var date: Date!
	
	@objc dynamic var warmUp = 0.0
	@objc dynamic var startSpeed = 0.0
	@objc dynamic var increase = 0.0
	@objc dynamic var frequency = 0.0
	
	@objc dynamic var kneeFlexibility = 0
	@objc dynamic var shinFlexibility = 0
	@objc dynamic var hitFootFlexibility = 0
	@objc dynamic var closedFistGroundFlexibility = 0
	@objc dynamic var handFlatGroundFlexibility = 0
	
	override static func primaryKey() -> String? {
		return "testID"
	}
	
	convenience init(test: Test) {
		self.init()
		
		testID = test.testID ?? 0
		user = UserObject(user: test.user)
		date = test.date
		
		warmUp = test.warmUp
		startSpeed = test.startSpeed
		increase = test.increase
		frequency = test.frequency
		
		kneeFlexibility = test.kneeFlexibility.rawValue
		shinFlexibility = test.shinFlexibility.rawValue
		hitFootFlexibility = test.hitFootFlexibility.rawValue
		closedFistGroundFlexibility = test.closedFistGroundFlexibility.rawValue
		handFlatGroundFlexibility = test.handFlatGroundFlexibility.rawValue
	}
}

enum Flexibility: Int, Codable {
	case weak, average, good, veryGood
}

class Test: NSObject, Codable {
	enum CodingKeys: String, CodingKey {
		case testID = "id"
		case user
		case date
		
		case warmUp
		case startSpeed
		case increase
		case frequency
		
		case kneeFlexibility
		case shinFlexibility
		case hitFootFlexibility
		case closedFistGroundFlexibility
		case handFlatGroundFlexibility
	}
	
	var testID: Int?
	var user: User
	var date: Date
	
	var warmUp: Double
	var startSpeed: Double
	var increase: Double
	var frequency: Double
	
	var kneeFlexibility: Flexibility
	var shinFlexibility: Flexibility
	var hitFootFlexibility: Flexibility
	var closedFistGroundFlexibility: Flexibility
	var handFlatGroundFlexibility: Flexibility
	
	init(user: User, date: Date, warmUp: Double, startSpeed: Double, increase: Double, frequency: Double, kneeFlexibility: Flexibility, shinFlexibility: Flexibility, hitFootFlexibility: Flexibility, closedFistGroundFlexibility: Flexibility, handFlatGroundFlexibility: Flexibility) {
		self.user = user
		self.date = date
		
		self.warmUp = warmUp
		self.startSpeed = startSpeed
		self.increase = increase
		self.frequency = frequency
		
		self.kneeFlexibility = kneeFlexibility
		self.shinFlexibility = shinFlexibility
		self.hitFootFlexibility = hitFootFlexibility
		self.closedFistGroundFlexibility = closedFistGroundFlexibility
		self.handFlatGroundFlexibility = handFlatGroundFlexibility
	}
	
	init(object: TestObject) {
		testID = object.testID
		user = User(object: object.user)
		date = object.date
		
		warmUp = object.warmUp
		startSpeed = object.startSpeed
		increase = object.increase
		frequency = object.frequency
		
		kneeFlexibility = Flexibility(rawValue: object.kneeFlexibility) ?? .weak
		shinFlexibility = Flexibility(rawValue: object.shinFlexibility) ?? .weak
		hitFootFlexibility = Flexibility(rawValue: object.hitFootFlexibility) ?? .weak
		closedFistGroundFlexibility = Flexibility(rawValue: object.closedFistGroundFlexibility) ?? .weak
		handFlatGroundFlexibility = Flexibility(rawValue: object.handFlatGroundFlexibility) ?? .weak
	}
}
