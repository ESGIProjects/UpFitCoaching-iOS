//
//  Measurements.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 22/06/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import Foundation
import RealmSwift

final class MeasurementsObject: Object {
	@objc dynamic var measurementsID = 0
	@objc dynamic var user: UserObject!
	@objc dynamic var date: Date!
	
	@objc dynamic var weight = 0.0
	@objc dynamic var height = 0.0
	
	@objc dynamic var hipCircumference = 0.0
	@objc dynamic var waistCircumference = 0.0
	@objc dynamic var thighCircumference = 0.0
	@objc dynamic var armCircumference = 0.0
	
	override static func primaryKey() -> String? {
		return "measurementsID"
	}
	
	convenience init(measurements: Measurements) {
		self.init()
		
		measurementsID = measurements.measurementsID ?? 0
		user = UserObject(user: measurements.user)
		date = measurements.date
		
		weight = measurements.weight
		height = measurements.height
		
		hipCircumference = measurements.hipCircumference
		waistCircumference = measurements.waistCircumference
		thighCircumference = measurements.thighCircumference
		armCircumference = measurements.armCircumference
	}
}

class Measurements: NSObject, Codable {
	enum CodingKeys: String, CodingKey {
		case measurementsID = "id"
		case user
		case date
		
		case weight
		case height
		
		case hipCircumference
		case waistCircumference
		case thighCircumference
		case armCircumference
	}
	
	var measurementsID: Int?
	var user: User
	var date: Date
	
	var weight: Double
	var height: Double
	
	var hipCircumference: Double
	var waistCircumference: Double
	var thighCircumference: Double
	var armCircumference: Double
	
	init(user: User, date: Date, weight: Double, height: Double, hipCircumference: Double, waistCircumference: Double, thighCircumference: Double, armCircumference: Double) {
		self.user = user
		self.date = date
		
		self.weight = weight
		self.height = height
		
		self.hipCircumference = hipCircumference
		self.waistCircumference = waistCircumference
		self.thighCircumference = thighCircumference
		self.armCircumference = armCircumference
	}
	
	init(object: MeasurementsObject) {
		measurementsID = object.measurementsID
		user = User(object: object.user)
		date = object.date
		
		weight = object.weight
		height = object.height
		
		hipCircumference = object.hipCircumference
		waistCircumference = object.waistCircumference
		thighCircumference = object.thighCircumference
		armCircumference = object.armCircumference
	}
}
