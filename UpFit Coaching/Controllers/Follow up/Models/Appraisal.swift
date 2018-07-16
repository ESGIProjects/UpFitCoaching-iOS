//
//  Appraisal.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 22/06/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
// Version 1.0

import Foundation
import RealmSwift

final class AppraisalObject: Object {
	@objc dynamic var appraisalID = 0
	@objc dynamic var user: UserObject!
	@objc dynamic var date: Date!
	
	@objc dynamic var goal = ""
	@objc dynamic var sessionsByWeek = 0
	
	@objc dynamic var contraindication = ""
	@objc dynamic var sportAntecedents = ""
	
	@objc dynamic var helpNeeded = false
	@objc dynamic var hasNutritionist = false
	@objc dynamic var comments = ""
	
	override static func primaryKey() -> String? {
		return "appraisalID"
	}
	
	convenience init(appraisal: Appraisal) {
		self.init()
		
		appraisalID = appraisal.appraisalID ?? 0
		user = UserObject(user: appraisal.user)
		date = appraisal.date
		
		goal = appraisal.goal
		sessionsByWeek = appraisal.sessionsByWeek
		
		contraindication = appraisal.contraindication
		sportAntecedents = appraisal.sportAntecedents
		
		helpNeeded = appraisal.helpNeeded
		hasNutritionist = appraisal.hasNutritionist
		comments = appraisal.comments
	}
}

class Appraisal: NSObject, Codable {
	enum CodingKeys: String, CodingKey {
		case appraisalID = "id"
		case user
		case date
		
		case goal
		case sessionsByWeek
		
		case contraindication
		case sportAntecedents
		
		case helpNeeded
		case hasNutritionist
		case comments
	}
	
	var appraisalID: Int?
	var user: User
	var date: Date
	
	var goal: String
	var sessionsByWeek: Int
	
	var contraindication: String
	var sportAntecedents: String
	
	var helpNeeded: Bool
	var hasNutritionist: Bool
	var comments: String
	
	init(user: User, date: Date, goal: String, sessionsByWeek: Int, contraindication: String, sportAntecedents: String, helpNeeded: Bool, hasNutritionist: Bool, comments: String) {
		self.user = user
		self.date = date
		
		self.goal = goal
		self.sessionsByWeek = sessionsByWeek
		
		self.contraindication = contraindication
		self.sportAntecedents = sportAntecedents
		
		self.helpNeeded = helpNeeded
		self.hasNutritionist = hasNutritionist
		self.comments = comments
	}
	
	init(object: AppraisalObject) {
		appraisalID = object.appraisalID
		user = User(object: object.user)
		date = object.date
		
		goal = object.goal
		sessionsByWeek = object.sessionsByWeek
		
		contraindication = object.contraindication
		sportAntecedents = object.sportAntecedents
		
		helpNeeded = object.helpNeeded
		hasNutritionist = object.hasNutritionist
		comments = object.comments
	}
}
