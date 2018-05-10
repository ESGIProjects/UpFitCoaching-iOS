//
//  Network.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 07/03/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import Foundation

class Network {
	
	enum HTTPMethod: String {
		case get	= "GET"
		case post	= "POST"
	}
	
	// MARK: - Perform call
	
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
	
	// MARK: - User management
	
	class func login(mail: String, password: String, completion: @escaping NetworkCallback) {
		let url = baseURL.appending("/signin/")
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
	
	// MARK: - Messages
	
	class func getMessages(for user: User, completion: @escaping NetworkCallback) {
		let url = baseURL.appending("/messages/")
		let parameters: [String: Any] = [
			"userId": user.userID
		]
		
		call(url, httpMethod: .get, parameters: parameters, completion: completion)
	}
	
	// MARK: - Events
	
	class func getEvents(for user: User, completion: @escaping NetworkCallback) {
		let url = baseURL.appending("/events/")
		let parameters: [String: Any] = [
			"userId": user.userID
		]
		
		call(url, httpMethod: .get, parameters: parameters, completion: completion)
	}
	
	class func addEvent(_ event: Event, completion: @escaping NetworkCallback) {
		let url = baseURL.appending("/events/")
		let parameters: [String: Any] = [
			"name": event.name,
			"client": event.client.userID,
			"coach": event.coach.userID,
			"start": event.start,
			"end": event.end,
			"created": event.created,
			"updated": event.updated
		]
		
		call(url, httpMethod: .post, parameters: parameters, completion: completion)
	}
}
