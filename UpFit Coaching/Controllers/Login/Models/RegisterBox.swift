//
//  RegisterBox.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 10/05/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import Foundation

class RegisterBox {
	var parameters = [String: Any]()
	
	var type: Int {
		get {
			guard let value = parameters["type"] as? Int else { return 0 }
			return value
		}
		set {
			parameters["type"] = newValue
		}
	}
	
	var mail: String {
		get {
			guard let value = parameters["mail"] as? String else { return "" }
			return value
		}
		set {
			parameters["mail"] = newValue
		}
	}
	
	var password: String {
		get {
			guard let value = parameters["password"] as? String else { return "" }
			return value
		}
		set {
			parameters["password"] = newValue
		}
	}
	
	var firstName: String {
		get {
			guard let value = parameters["firstName"] as? String else { return "" }
			return value
		}
		set {
			parameters["firstName"] = newValue
		}
	}
	
	var lastName: String {
		get {
			guard let value = parameters["lastName"] as? String else { return "" }
			return value
		}
		set {
			parameters["lastName"] = newValue
		}
	}
	
	var sex: Int {
		get {
			guard let value = parameters["sex"] as? Int else { return 1 }
			return value
		}
		set {
			parameters["sex"] = newValue
		}
	}
	
	var city: String {
		get {
			guard let value = parameters["city"] as? String else { return "" }
			return value
		}
		set {
			parameters["city"] = newValue
		}
	}
	
	var phoneNumber: String {
		get {
			guard let value = parameters["phoneNumber"] as? String else { return "" }
			return value
		}
		set {
			parameters["phoneNumber"] = newValue
		}
	}
	
	var address: String? {
		get {
			guard let value = parameters["address"] as? String? else { return nil }
			return value
		}
		set {
			parameters["address"] = newValue
		}
	}
	
	var birthDate: Date? {
		get {
			guard let value = parameters["birthDate"] as? Date? else { return nil }
			return value
		}
		set {
			parameters["birthDate"] = newValue
		}
	}
}
