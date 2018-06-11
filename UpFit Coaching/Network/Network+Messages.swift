//
//  Network+Messages.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 11/06/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import Foundation

extension Network {
	class func getMessages(for user: User, completion: @escaping NetworkCallback) {
		let url = baseURL.appending("/messages/")
		let parameters: [String: Any] = [
			"userId": user.userID
		]
		
		call(url, httpMethod: .get, parameters: parameters, completion: completion)
	}
}
