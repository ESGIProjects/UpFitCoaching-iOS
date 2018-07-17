//
//  Network.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 07/03/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
// Version 1.0

import UIKit
import JWT

class Network {
	
	enum HTTPMethod: String {
		case get	= "GET"
		case post	= "POST"
		case put	= "PUT"
		case delete	= "DELETE"
	}
	
	struct Token: Codable {
		var token: String
	}
	
	// MARK: - Perform call
	
	typealias NetworkCallback = ((Data?, URLResponse?, Error?) -> Void)
	static var baseURL = "http://212.47.234.147"

	class func call(_ stringUrl: String, httpMethod: HTTPMethod, parameters: [String: Any], useToken: Bool = true, completion: @escaping NetworkCallback) {
		guard var request = createRequest(for: stringUrl, method: httpMethod, with: parameters) else { return }
		
		if useToken, let token = UserDefaults.standard.object(forKey: "authToken") as? String {			
			if !isTokenValid(token) {
				refreshToken(token) {
					call(stringUrl, httpMethod: httpMethod, parameters: parameters, completion: completion)
				}
				return
			}
			
			request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
		}
		
		let session = URLSession(configuration: .default)
		session.dataTask(with: request, completionHandler: completion).resume()
	}
	
	// MARK: - Actions

	class func isSuccess(response: URLResponse?, successCode: Int, caller: String = #function) -> Bool {
		guard let response = response as? HTTPURLResponse else { return false }		
		return response.statusCode == successCode
	}
	
	class func displayError(_ controller: UIViewController?, from data: Data) {
		let decoder = JSONDecoder()
		guard let errorMessage = try? decoder.decode(ErrorMessage.self, from: data) else { return }
				
		DispatchQueue.main.async {
			controller?.presentAlert(title: "error".localized, message: errorMessage.message.localized)
		}
	}
	
	// MARK: - Helpers
	
	private class func parseParameters(_ parameters: [String: Any]) -> String {
		var callParameters = [String]()
		
		for (key, value) in parameters {
			callParameters.append("\(key)=\(value)")
		}
		
		return callParameters.map({ String($0) }).joined(separator: "&")
	}
	
	private class func createRequest(for stringUrl: String, method: HTTPMethod, with parameters: [String: Any]) -> URLRequest? {
		var request: URLRequest
		
		let parameterString = parseParameters(parameters)
		
		switch method {
			
		case .get, .delete:
			guard let url = URL(string: stringUrl.appending("?").appending(parameterString)) else { return nil }
			request = URLRequest(url: url)
			
		case .post, .put:
			guard let url = URL(string: stringUrl) else { return nil }
			request = URLRequest(url: url)
			request.httpBody = parameterString.data(using: .utf8)
		}
		
		if method == .put {
			request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
		}
		
		request.httpMethod = method.rawValue
		return request
	}
	
	private class func isTokenValid(_ token: String) -> Bool {
		guard let secretKey = "ThisIsASecretKey".data(using: .utf8),
			let claims: ClaimSet = try? JWT.decode(token, algorithm: .hs256(secretKey)) else { return false }
		
		do {
			try claims.validateExpiary()
			return true
		} catch {
			return false
		}
	}
	
	private class func refreshRequest(with token: String) -> URLRequest {
		var request = URLRequest(url: URL(string: baseURL.appending("/login/refreshToken/"))!)
		request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
		
		return request
	}
	
	private class func refreshToken(_ token: String, handler: @escaping () -> Void) {
		let session = URLSession(configuration: .default)
		session.dataTask(with: refreshRequest(with: token), completionHandler: { data, response, _ in
			guard let data = data else { return }
			
			if isSuccess(response: response, successCode: 200) {
				guard let token = try? JSONDecoder().decode(Token.self, from: data) else { return }
				UserDefaults.standard.set(token.token, forKey: "authToken")
				handler()
			}
		}).resume()
	}
}
