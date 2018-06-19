//
//  User.swift
//  UpFit Coaching
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
	@objc dynamic var sex = 0
	@objc dynamic var phoneNumber = ""
	
	@objc dynamic var address: String?
	@objc dynamic var birthDate: Date?
	@objc dynamic var coach: UserObject?
	
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
		sex = user.sex
		phoneNumber = user.phoneNumber
		
		address = user.address
		birthDate = user.birthDate
		
		if let coach = user.coach {
			self.coach = UserObject(user: coach)
		}
	}
}

class User: NSObject, Codable {
	enum CodingKeys: String, CodingKey {
		case userID = "id"
		case type
		case mail
		
		case firstName
		case lastName
		
		case city
		case sex
		case phoneNumber
		
		case address
		case birthDate
		case coach
	}
	
	var userID: Int
	var type: Int
	var mail: String
	
	var firstName: String
	var lastName: String
	
	var city: String
	var sex: Int
	var phoneNumber: String
	
	var address: String?
	var birthDate: Date?
	var coach: User?
	
	static let all = FetchRequest<[User], UserObject>(predicate: nil, sortDescriptors: [], transformer: { $0.map(User.init) })
	
	init(id: Int, type: Int, mail: String, firstName: String, lastName: String, city: String, phoneNumber: String) {
		userID = id
		self.type = type
		self.mail = mail
		
		self.firstName = firstName
		self.lastName = lastName
		
		self.city = city
		sex = 0
		self.phoneNumber = phoneNumber
	}
	
	init(object: UserObject) {
		userID = object.userID
		type = object.type
		mail = object.mail
		
		firstName = object.firstName
		lastName = object.lastName
		
		city = object.city
		sex = object.sex
		phoneNumber = object.phoneNumber
		
		address = object.address
		birthDate = object.birthDate
		
		if let coach = object.coach {
			self.coach = User(object: coach)
		}
	}
	
	init(json: [String: Any]) {
		userID = json["id"] as? Int ?? 0
		type = json["type"] as? Int ?? 0
		mail = json["mail"] as? String ?? ""
		
		firstName = json["firstName"] as? String ?? ""
		lastName = json["lastName"] as? String ?? ""
		
		city = json["city"] as? String ?? ""
		sex = json["sex"] as? Int ?? 0
		phoneNumber = json["phoneNumber"] as? String ?? ""
		
		address = json["address"] as? String
		
		if let birthDate = json["birthDate"] as? String {
			self.birthDate = DateFormatter.date.date(from: birthDate)
		}
		
		if let coach = json["coach"] as? [String: Any] {
			self.coach = User(json: coach)
		}
	}
	
	override func isEqual(_ object: Any?) -> Bool {
		return userID == (object as? User)?.userID
	}
}
