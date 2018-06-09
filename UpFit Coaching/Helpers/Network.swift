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
		case put	= "PUT"
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
		case .post, .put:
			guard let url = URL(string: stringUrl) else { return }
			request = URLRequest(url: url)
			request.httpBody = parameterString.data(using: .utf8)
		}
		
		if httpMethod == .put {
			request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
		}
		
		request.httpMethod = httpMethod.rawValue
		
		let session = URLSession(configuration: .default)
		session.dataTask(with: request, completionHandler: completion).resume()
	}
	
	// MARK: - User management
	
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
	
	class func addEvent(_ event: Event, completion: @escaping NetworkCallback) {
		let url = baseURL.appending("/events/")
		
		let dateFormatter = DateFormatter.time
		
		let parameters: [String: Any] = [
			"name": event.name,
			"type": event.type,
			"firstUser": event.firstUser.userID,
			"secondUser": event.secondUser.userID,
			"start": dateFormatter.string(from: event.start),
			"end": dateFormatter.string(from: event.end),
			"created": dateFormatter.string(from: event.created),
			"createdBy": event.createdBy.userID
		]
		
		call(url, httpMethod: .post, parameters: parameters, completion: completion)
	}
	
	class func updateEvent(_ event: Event, completion: @escaping NetworkCallback) {
		guard let eventId = event.eventID else { return }
		
		let url = baseURL.appending("/events/")
		
		let dateFormatter = DateFormatter.time
		
		let parameters: [String: Any] = [
			"eventId": eventId,
			"name": event.name,
			"start": dateFormatter.string(from: event.start),
			"end": dateFormatter.string(from: event.end),
			"updated": dateFormatter.string(from: event.updated),
			"updatedBy": event.updatedBy.userID
		]
		
		call(url, httpMethod: .put, parameters: parameters, completion: completion)
	}
	
	class func getThreads(for forumId: Int, completion: @escaping NetworkCallback) {
		let url = baseURL.appending("/threads/")
		let parameters: [String: Any] = [
			"forumId": forumId
		]
		
		call(url, httpMethod: .get, parameters: parameters, completion: completion)
	}
	
	class func createThread(_ thread: ForumThread, with post: Post, completion: @escaping NetworkCallback) {
		let url = baseURL.appending("/thread/")
		
		let dateFormatter = DateFormatter.time
		
		let parameters: [String: Any] = [
			"title": thread.title,
			"date": dateFormatter.string(from: post.date),
			"content": post.content,
			"forumId": thread.forum.forumID,
			"userId": post.user.userID
		]
		
		call(url, httpMethod: .post, parameters: parameters, completion: completion)
	}
	
	class func getPosts(for thread: ForumThread, completion: @escaping NetworkCallback) {
		let url = baseURL.appending("/thread/")
		let parameters: [String: Any] = [
			"threadId": thread.threadID
		]
		
		call(url, httpMethod: .get, parameters: parameters, completion: completion)
	}
	
	class func addPost(_ post: Post, to thread: ForumThread, completion: @escaping NetworkCallback) {
		let url = baseURL.appending("/post/")
		
		let dateFormatter = DateFormatter.time
		
		let parameters: [String: Any] = [
			"threadId": thread.threadID,
			"date": dateFormatter.string(from: post.date),
			"content": post.content,
			"userId": post.user.userID
		]
		
		call(url, httpMethod: .post, parameters: parameters, completion: completion)
	}
	
	class func isSuccess(response: URLResponse?, successCode: Int, caller: String = #function) -> Bool {
		guard let response = response as? HTTPURLResponse else { return false }
		print(caller, "Status code:", response.statusCode)
		
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
