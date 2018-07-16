//
//  Prescription.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 03/07/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
// Version 1.0

import Foundation
import RealmSwift

final class PrescriptionObject: Object {
	@objc dynamic var prescriptionID = 0
	@objc dynamic var user: UserObject!
	@objc dynamic var date: Date!
	var exercises = List<ExerciseObject>()
	
	override static func primaryKey() -> String? {
		return "prescriptionID"
	}
	
	convenience init(prescription: Prescription) {
		self.init()
		
		prescriptionID = prescription.prescriptionID ?? 0
		user = UserObject(user: prescription.user)
		date = prescription.date
		
		prescription.exercises
			.map(ExerciseObject.init)
			.forEach { exercises.append($0) }
	}
}

class Prescription: NSObject, Codable {
	enum CodingKeys: String, CodingKey {
		case prescriptionID = "id", user, date, exercises
	}
	
	var prescriptionID: Int?
	var user: User
	var date: Date
	var exercises: [Exercise]
	
	init(user: User, date: Date, exercises: [Exercise]) {
		self.user = user
		self.date = date
		self.exercises = exercises
	}
	
	init(object: PrescriptionObject) {
		prescriptionID = object.prescriptionID
		user = User(object: object.user)
		date = object.date
		exercises = object.exercises.map(Exercise.init)
	}
}
