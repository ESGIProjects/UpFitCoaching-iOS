//
//  Codables.swift
//  Coaching
//
//  Created by Jason Pierna on 10/04/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

//swiftlint:disable identifier_name

import Foundation

struct Client: Codable {
	var id: Int
	var type: Int
	var mail: String
	var firstName: String
	var lastName: String
	var birthDate: String
	var city: String
	var phoneNumber: String
}

struct ErrorMessage: Codable {
	var message: String
}

struct CodableMessage: Codable {
	var message: String
	var fromId: Int
	var fromType: Int
	var toId: Int
	var toType: Int
	var date: String
}
