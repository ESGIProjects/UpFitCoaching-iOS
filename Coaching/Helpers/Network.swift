//
//  Network.swift
//  Coaching
//
//  Created by Jason Pierna on 07/03/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
	case get	= "GET"
	case post	= "POST"
}

class Network {
	
	typealias NetworkCallback = ((Data?, URLResponse?, Error?) -> Void)
	private static var baseURL = "http://212.47.234.147"
	
	private static func call(_ stringUrl: String, httpMethod: HTTPMethod, parameters: [String: Any], completion: @escaping NetworkCallback) {
		guard let url = URL(string: stringUrl) else { return }
		
		var callParameters = [String]()
		
		for (key, value) in parameters {
			callParameters.append("\(key)=\(value)")
		}
		let parameterString = callParameters.map({ String($0) }).joined(separator: "&")
		
		var request = URLRequest(url: url)
		request.httpMethod = httpMethod.rawValue
		request.httpBody = parameterString.data(using: .utf8)
		
		let session = URLSession(configuration: .default)
		session.dataTask(with: request, completionHandler: completion).resume()
	}
	
	static func login(mail: String, password: String, completion: @escaping NetworkCallback) {
		let url = baseURL.appending("/signin/")
		let parameters = [
			"mail": mail,
			"password": password
		]
		
		call(url, httpMethod: .post, parameters: parameters, completion: completion)
	}
	
	static func register(mail: String, password: String, type: Int, firstName: String, lastName: String, birthDate: String, city: String, phoneNumber: String, completion: @escaping NetworkCallback) {
		let url = baseURL.appending("/signup/")
		let parameters: [String: Any] = [
			"mail": mail,
			"password": password,
			"type": type,
			"firstName": firstName,
			"lastName": lastName,
			"birthDate": birthDate,
			"city": city,
			"phoneNumber": phoneNumber
		]
		
		call(url, httpMethod: .post, parameters: parameters, completion: completion)
	}
}
