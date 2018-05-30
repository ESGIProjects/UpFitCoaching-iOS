//
//  Network.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 07/03/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit

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
	
	class func isMailExists(mail: String, completion: @escaping NetworkCallback) {
		let url = baseURL.appending("/checkmail/")
		let parameters: [String: Any] = [
			"mail": mail
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
	
	class func addEvent(_ event: Event, by user: User, completion: @escaping NetworkCallback) {
		let url = baseURL.appending("/events/")
		
		let dateFormatter = DateFormatter.time
		
		let parameters: [String: Any] = [
			"name": event.name,
			"type": event.type,
			"client": event.client.userID,
			"coach": event.coach.userID,
			"start": dateFormatter.string(from: event.start),
			"end": dateFormatter.string(from: event.end),
			"created": dateFormatter.string(from: event.created),
			"createdBy": user.userID
		]
		
		call(url, httpMethod: .post, parameters: parameters, completion: completion)
	}
	
	class func isSuccess(response: URLResponse?, successCode: Int) -> Bool {
		guard let response = response as? HTTPURLResponse else { return false }
		print("Status code:", response.statusCode)
		
		return response.statusCode == successCode
	}
	
	class func displayError(_ controller: UIViewController?, from data: Data) {
		let decoder = JSONDecoder()
		guard let errorMessage = try? decoder.decode(ErrorMessage.self, from: data) else { return }
				
		DispatchQueue.main.async {
			controller?.presentAlert(title: "error".localized, message: errorMessage.message.localized)
		}
	}
}
