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
	
	class func getMeasurements(for user: User, completion: @escaping NetworkCallback) {
		let url = baseURL.appending("/measurements/")
		let parameters: [String: Any] = [
			"userId": user.userID
		]
		
		call(url, httpMethod: .get, parameters: parameters, completion: completion)
	}
	
	class func getTests(for user: User, completion: @escaping NetworkCallback) {
		let url = baseURL.appending("/tests/")
		let parameters: [String: Any] = [
			"userId": user.userID
		]
		
		call(url, httpMethod: .get, parameters: parameters, completion: completion)
	}
}
