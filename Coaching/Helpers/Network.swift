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
	
	private class func call(_ stringUrl: String, httpMethod: HTTPMethod, parameters: [String: Any], completion: @escaping NetworkCallback) {
		var request: URLRequest
		var callParameters = [String]()
		
		for (key, value) in parameters {
			callParameters.append("\(key)=\(value)")
		}
		let parameterString = callParameters.map({ String($0) }).joined(separator: "&")
		
		switch httpMethod {
		case .get:
			guard let url = URL(string: stringUrl.appending("?").appending(parameterString)) else { return }
			request = URLRequest(url: url)
		case .post:
			guard let url = URL(string: stringUrl) else { return }
			request = URLRequest(url: url)
			request.httpBody = parameterString.data(using: .utf8)
		}
		
		request.httpMethod = httpMethod.rawValue
		
		let session = URLSession(configuration: .default)
		session.dataTask(with: request, completionHandler: completion).resume()
	}
	
	class func login(mail: String, password: String, completion: @escaping NetworkCallback) {
		let url = baseURL.appending("/signin/")
		let parameters: [String: Any] = [
			"mail": mail,
			"password": password
		]
		
		call(url, httpMethod: .post, parameters: parameters, completion: completion)
	}
	
	class func register(mail: String, password: String, type: Int, firstName: String, lastName: String, birthDate: String, city: String, phoneNumber: String, completion: @escaping NetworkCallback) {
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
	
	class func getConversation(between first: Int, and second: Int, page: Int = 0, completion: @escaping NetworkCallback) {
		let url = baseURL.appending("/conversation/")
		let parameters: [String: Any] = [
			"coachId": first,
			"clientId": second,
			"page": page
		]
		
		call(url, httpMethod: .get, parameters: parameters, completion: completion)
	}
}
