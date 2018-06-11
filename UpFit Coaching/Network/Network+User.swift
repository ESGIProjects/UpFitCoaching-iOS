//
//  Network+User.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 11/06/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import Foundation

// MARK: - User routes
extension Network {
	
	class func isMailExists(mail: String, completion: @escaping NetworkCallback) {
		let url = baseURL.appending("/checkmail/")
		let parameters: [String: Any] = [
			"mail": mail
		]
		
		call(url, httpMethod: .post, parameters: parameters, completion: completion)
	}
	
	class func login(mail: String, password: String, completion: @escaping NetworkCallback) {
		let url = Network.baseURL.appending("/signin/")
		let parameters: [String: Any] = [
			"mail": mail,
			"password": password
		]
		
		call(url, httpMethod: .post, parameters: parameters, completion: completion)
	}
	
	class func register(with parameters: [String: Any], completion: @escaping NetworkCallback) {
		let url = baseURL.appending("/signup/")
		
		call(url, httpMethod: .post, parameters: parameters, completion: completion)
	}
	
	class func registerToken(_ token: String, oldToken: String? = nil, for user: User) {
		let url = baseURL.appending("/token/")
		var parameters: [String: Any] = [
			"token": token,
			"userId": user.userID
		]
		
		if let oldToken = oldToken {
			parameters["oldToken"] = oldToken
		}
		
		call(url, httpMethod: .put, parameters: parameters) { _, response, _ in
			_ = Network.isSuccess(response: response, successCode: 201)
		}
	}
	
	class func updateProfile(for user: User, values: [String: String], completion: @escaping NetworkCallback) {
		let url = baseURL.appending("/users/")
		
		var parameters = values as [String: Any]
		parameters["userId"] = user.userID
		
		call(url, httpMethod: .put, parameters: parameters, completion: completion)
	}
}
