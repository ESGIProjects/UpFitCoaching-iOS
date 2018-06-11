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
	static var baseURL = "http://212.47.234.147"

	class func call(_ stringUrl: String, httpMethod: HTTPMethod, parameters: [String: Any], completion: @escaping NetworkCallback) {
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
