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
	@objc dynamic var type = 2
	@objc dynamic var mail = ""
	@objc dynamic var firstName = ""
	@objc dynamic var lastName = ""
	@objc dynamic var birhDate = Date()
	@objc dynamic var city = ""
	@objc dynamic var phoneNumber = ""
	
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
		birhDate = user.birhDate
		city = user.city
		phoneNumber = user.phoneNumber
	}
}

struct User {
	let userID: Int
	let type: Int
	let mail: String
	let firstName: String
	let lastName: String
	let birhDate: Date
	let city: String
	let phoneNumber: String
	
	static let all = FetchRequest<[User], UserObject>(predicate: nil, sortDescriptors: [], transformer: { $0.map(User.init) })
}

extension User {
	init(object: UserObject) {
		userID = object.userID
		type = object.type
		mail = object.mail
		firstName = object.firstName
		lastName = object.lastName
		birhDate = object.birhDate
		city = object.city
		phoneNumber = object.phoneNumber
	}
}
