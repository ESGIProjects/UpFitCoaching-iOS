//
//  Database+Helpers.swift
//  UpFit Coaching
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
	
	func getThreads(for forumId: Int) -> [ForumThread] {
		
		// Creating the fetch request
		let fetchRequest = FetchRequest<[ForumThread], ForumThreadObject>(predicate: NSPredicate(format: "forum.forumID == %d", forumId),
																		  sortDescriptors: [],
																		  transformer: { $0.map(ForumThread.init) })
		
		return fetch(using: fetchRequest)
	}
	
	func getPosts(for thread: ForumThread) -> [Post] {
		// Creating the fetch request
		let fetchRequest = FetchRequest<[Post], PostObject>(predicate: NSPredicate(format: "thread.threadID == %d", thread.threadID),
															sortDescriptors: [SortDescriptor(keyPath: "date")],
															transformer: { $0.map(Post.init) })
		
		return fetch(using: fetchRequest)
	}
	
	func getLastAppraisal(for user: User) -> Appraisal? {
		
		// Creating the fetch request
		let fetchRequest = FetchRequest<[Appraisal], AppraisalObject>(predicate: NSPredicate(format: "user.userID == %d", user.userID),
																	  sortDescriptors: [SortDescriptor(keyPath: "date", ascending: false)],
																	  transformer: { $0.map(Appraisal.init) })
		
		return fetch(using: fetchRequest).first
	}
	
	func getMeasurements(for user: User) -> [Measurements] {
		let fetchRequest = FetchRequest<[Measurements], MeasurementsObject>(predicate: NSPredicate(format: "user.userID == %d", user.userID),
																			sortDescriptors: [SortDescriptor(keyPath: "date", ascending: false)],
																			transformer: { $0.map(Measurements.init) })
		
		return fetch(using: fetchRequest)
	}
	
	func getLastMeasurement(for user: User) -> Measurements? {
		return getMeasurements(for: user).first
	}
	
	func getTests(for user: User) -> [Test] {
		let fetchRequest = FetchRequest<[Test], TestObject>(predicate: NSPredicate(format: "user.userID == %d", user.userID),
																			sortDescriptors: [SortDescriptor(keyPath: "date", ascending: false)],
																			transformer: { $0.map(Test.init) })
		
		return fetch(using: fetchRequest)
	}
	
	func getLastTest(for user: User) -> Test? {
		return getTests(for: user).first
	}
	
	func getPrescriptions(for user: User) -> [Prescription] {
		let fetchRequest = FetchRequest<[Prescription], PrescriptionObject>(predicate: NSPredicate(format: "user.userID == %d", user.userID),
															sortDescriptors: [SortDescriptor(keyPath: "date", ascending: false)],
															transformer: { $0.map(Prescription.init) })
		
		return fetch(using: fetchRequest)
	}
	
	func getLastPrescription(for user: User) -> Prescription? {
		return getPrescriptions(for: user).first
	}
}
