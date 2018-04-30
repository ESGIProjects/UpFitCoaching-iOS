//
//  Database+Helpers.swift
//  Coaching
//
//  Created by Jason Pierna on 18/04/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import Foundation
import RealmSwift

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
	
	func getMessages(between first: User, and second: User) -> [Message] {
		
		// Creating the fetch request
		let fetchRequest = FetchRequest<[Message], MessageObject>(predicate: NSPredicate(format: "(sender.userID == %d AND receiver.userID = %d) OR (sender.userID == %d AND receiver.userID == %d)", first.userID, second.userID, second.userID, first.userID),
																  sortDescriptors: [SortDescriptor(keyPath: "date")],
																  transformer: { $0.map(Message.init) })
		
		return fetch(using: fetchRequest)
	}
}
