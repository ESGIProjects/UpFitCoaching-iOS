//
//  UpFitCoachingTests.swift
//  UpFit Coaching Tests
//
//  Created by Jason Pierna on 17/07/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import Firebase
import XCTest
@testable import UpFit_Coaching

class UpFitCoachingTests: XCTestCase {	
	func testCurrentUser() {
		let userID = UserDefaults.standard.integer(forKey: "userID")
		
		if userID > 0 {
			let currentUser = Database().getCurrentUser()
			XCTAssertNotNil(currentUser)
			XCTAssert(currentUser?.userID == userID)
		} else {
			XCTAssertNil(Database().getCurrentUser())
		}
	}
    
    func testMailValid() {
		let loginController = LoginController()
		XCTAssert(loginController.isMailValid("thisismymail@upfit.fr"))
		XCTAssertFalse(loginController.isMailValid("test"))
    }
	
	func testRegisterUnserialize() {
		let registerController = RegisterController()
		
		guard let goodData = "{\"id\":8,\"token\":\"tokentokentoken\"}".data(using: .utf8),
			let wrongData1 = "{id: \"1\", token: tokentokentoken}".data(using: .utf8),
			let wrongData2 = "{\"id\": \"1\", \"token\": tokentokentoken}".data(using: .utf8)else { return }
		
		let goodTuple = registerController.unserialize(goodData)
		let wrongTuple1 = registerController.unserialize(wrongData1)
		let wrongTuple2 = registerController.unserialize(wrongData2)
		
		XCTAssert(goodTuple.id == 8)
		XCTAssert(goodTuple.token == "tokentokentoken")
		XCTAssertNil(wrongTuple1.id)
		XCTAssertNil(wrongTuple1.token)
		XCTAssertNil(wrongTuple2.id)
		XCTAssertNil(wrongTuple2.token)
	}
	
	func testMeasurements() {
		// Create fake user
		let user = User(id: 1, type: 0, mail: "mail@mail.fr", firstName: "Name", lastName: "Name", city: "City", phoneNumber: "PhoneNumber")
		user.birthDate = Date(timeIntervalSince1970: 0)
		
		// Fake measurements
		let targetDate = Date(timeIntervalSince1970: 1531859631) // age 48
		let measurements = Measurements(user: user, date: targetDate, weight: 98.0, height: 181.0, hipCircumference: 0.0, waistCircumference: 0.0, thighCircumference: 0.0, armCircumference: 0.0)
		
		let followUpController = FollowUpController()
		let bfp = followUpController.computeBFP(for: measurements)
		let bmi = followUpController.computeBMI(for: user, with: measurements, and: bfp)
		
		XCTAssert(ceil(bfp) == 30)
		XCTAssert(ceil(bmi!) == 53)
	}
}
