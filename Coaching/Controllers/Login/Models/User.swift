//
//  User.swift
//  Coaching
//
//  Created by Jason Pierna on 17/04/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import Foundation
import RealmSwift

final class UserObject: Object {
	@objc dynamic var userID = 0
	@objc dynamic var type = 0
	@objc dynamic var mail = ""
	@objc dynamic var firstName = ""
	@objc dynamic var lastName = ""
	@objc dynamic var city = ""
	@objc dynamic var phoneNumber = ""
	@objc dynamic var address = ""
	@objc dynamic var birthDate: Date?
	
	override static func primaryKey() -> String? {
		return "userID"
	}
	
	convenience init(user: User) {
		self.init()
		
		userID = user.userID
		type = user.type
		mail = user.mail
		firstName = user.firstName
		lastName = user.lastName
		city = user.city
		phoneNumber = user.phoneNumber
		address = user.address ?? ""
		birthDate = user.birthDate
	}
}

struct User: Codable {
	enum CodingKeys: String, CodingKey {
		case userID = "id"
		case type
		case mail
		case firstName
		case lastName
		case city
		case phoneNumber
		case address
		case birthDate
	}
	
	var userID: Int
	var type: Int
	var mail: String
	var firstName: String
	var lastName: String
	var city: String
	var phoneNumber: String
	var address: String?
	var birthDate: Date?
	
	static let all = FetchRequest<[User], UserObject>(predicate: nil, sortDescriptors: [], transformer: { $0.map(User.init) })
}

extension User {
	init(object: UserObject) {
		userID = object.userID
		type = object.type
		mail = object.mail
		firstName = object.firstName
		lastName = object.lastName
		city = object.city
		phoneNumber = object.phoneNumber
		address = object.address
		birthDate = object.birthDate
	}
}
