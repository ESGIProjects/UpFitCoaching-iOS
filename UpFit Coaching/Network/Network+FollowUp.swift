//
//  Network+FollowUp.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 22/06/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import Foundation

extension Network {
	class func getLastAppraisal(for user: User, completion: @escaping NetworkCallback) {
		let url = baseURL.appending("/appraisals/")
		let parameters: [String: Any] = [
			"userId": user.userID
		]
		
		call(url, httpMethod: .get, parameters: parameters, completion: completion)
	}
	
	class func postAppraisal(_ appraisal: Appraisal, completion: @escaping NetworkCallback) {
		let url = baseURL.appending("/appraisals/")
		
		let dateFormatter = DateFormatter.time
		
		let parameters: [String: Any] = [
			"userId": appraisal.user.userID,
			"date": dateFormatter.string(from: appraisal.date),
			"goal": appraisal.goal,
			"sessionsByWeek": appraisal.sessionsByWeek,
			"contraindication": appraisal.contraindication,
			"sportAntecedents": appraisal.sportAntecedents,
			"helpNeeded": appraisal.helpNeeded,
			"hasNutritionist": appraisal.hasNutritionist,
			"comments": appraisal.comments
		]
		
		call(url, httpMethod: .post, parameters: parameters, completion: completion)
	}
	
	class func getMeasurements(for user: User, completion: @escaping NetworkCallback) {
		let url = baseURL.appending("/measurements/")
		let parameters: [String: Any] = [
			"userId": user.userID
		]
		
		call(url, httpMethod: .get, parameters: parameters, completion: completion)
	}
	
	class func postMeasurements(_ measurements: Measurements, completion: @escaping NetworkCallback) {
		let url = baseURL.appending("/measurements/")
		
		let dateFormatter = DateFormatter.time
		
		let parameters: [String: Any] = [
			"userId": measurements.user.userID,
			"date": dateFormatter.string(from: measurements.date),
			"weight": measurements.weight,
			"height": measurements.height,
			"hipCircumference": measurements.hipCircumference,
			"waistCircumference": measurements.waistCircumference,
			"thighCircumference": measurements.thighCircumference,
			"armCircumference": measurements.armCircumference
		]
		
		call(url, httpMethod: .post, parameters: parameters, completion: completion)
	}
	
	class func getTests(for user: User, completion: @escaping NetworkCallback) {
		let url = baseURL.appending("/tests/")
		let parameters: [String: Any] = [
			"userId": user.userID
		]
		
		call(url, httpMethod: .get, parameters: parameters, completion: completion)
	}
	
	class func postTest(_ test: Test, completion: @escaping NetworkCallback) {
		let url = baseURL.appending("/tests/")
		
		let dateFormatter = DateFormatter.time
		
		let parameters: [String: Any] = [
			"userId": test.user.userID,
			"date": dateFormatter.string(from: test.date),
			"warmUp": test.warmUp,
			"startSpeed": test.startSpeed,
			"increase": test.increase,
			"frequency": test.frequency,
			"kneeFlexibility": test.kneeFlexibility.rawValue,
			"shinFlexibility": test.shinFlexibility.rawValue,
			"hitFootFlexibility": test.hitFootFlexibility.rawValue,
			"closedFistGroundFlexibility": test.closedFistGroundFlexibility.rawValue,
			"handFlatGroundFlexibility": test.handFlatGroundFlexibility.rawValue
		]
		
		call(url, httpMethod: .post, parameters: parameters, completion: completion)
	}
}
