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
	let type: RealmOptional<Int> = RealmOptional(2)
	@objc dynamic var mail = ""
	@objc dynamic var firstName = ""
	@objc dynamic var lastName = ""
	@objc dynamic var birthDate = Date()
	@objc dynamic var city = ""
	@objc dynamic var phoneNumber = ""
	
	override static func primaryKey() -> String? {
		return "userID"
	}
	
	convenience init(user: User) {
		self.init()
		
		userID = user.userID
		type.value = user.type
		mail = user.mail
		firstName = user.firstName
		lastName = user.lastName
		birthDate = user.birthDate
		city = user.city
		phoneNumber = user.phoneNumber
	}
}

struct User: Codable {
	enum CodingKeys: String, CodingKey {
		case userID = "id"
		case type
		case mail
		case firstName
		case lastName
		case birthDate
		case city
		case phoneNumber
	}
	
	var userID: Int
	var type: Int?
	var mail: String
	var firstName: String
	var lastName: String
	var birthDate: Date
	var city: String
	var phoneNumber: String
	
	static let all = FetchRequest<[User], UserObject>(predicate: nil, sortDescriptors: [], transformer: { $0.map(User.init) })
}

extension User {
	init(object: UserObject) {
		userID = object.userID
		type = object.type.value
		mail = object.mail
		firstName = object.firstName
		lastName = object.lastName
		birthDate = object.birthDate
		city = object.city
		phoneNumber = object.phoneNumber
	}
}
