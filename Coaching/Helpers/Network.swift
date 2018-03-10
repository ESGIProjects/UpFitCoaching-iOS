//
//  Network.swift
//  Coaching
//
//  Created by Jason Pierna on 07/03/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import Foundation

class Network {
	
	typealias NetworkCallback = ((Data?, URLResponse?, Error?) -> Void)
	private static var baseURL = "http://localhost:8000"
	
	private static func call(_ stringUrl: String, httpMethod: String, parameters: [String: Any], completion: @escaping NetworkCallback) {
		guard let url = URL(string: stringUrl) else { return }
		
		var callParameters = [String]()
		
		for (key, value) in parameters {
			callParameters.append("\(key)=\(value)")
		}
		let parameterString = callParameters.map({ String($0) }).joined(separator: "&")
		
		var request = URLRequest(url: url)
		request.httpMethod = httpMethod
		request.httpBody = parameterString.data(using: .utf8)
		
		let session = URLSession(configuration: .default)
		session.dataTask(with: request, completionHandler: completion).resume()
	}
	
	static func login(mail: String, password: String, completion: @escaping NetworkCallback) {
		let url = baseURL.appending("/signin/")
		let parameters = [
			"mail": mail,
			"passwd": password
		]
		
		call(url, httpMethod: "POST", parameters: parameters, completion: completion)
	}
}
