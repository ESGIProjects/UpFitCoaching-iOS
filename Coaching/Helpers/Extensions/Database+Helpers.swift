//
//  Database+Helpers.swift
//  Coaching
//
//  Created by Jason Pierna on 18/04/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import Foundation

extension Database {
	func getCurrentUser() -> User? {
		
		// Getting the current user ID from UserDefaults
		let userID = UserDefaults.standard.integer(forKey: "userID")
		
		// Creating the fetch request
		let fetchRequest = FetchRequest<[User], UserObject>(predicate: NSPredicate(format: "userID == %d", userID),
															sortDescriptors: [],
															transformer: { $0.map(User.init) })
		
		return fetch(using: fetchRequest).first
	}
}
