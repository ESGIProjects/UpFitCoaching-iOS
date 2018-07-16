//
//  Network+Events.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 11/06/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import Foundation

extension Network {
	
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
			"type": event.type,
			"status": event.status,
			"start": dateFormatter.string(from: event.start),
			"end": dateFormatter.string(from: event.end),
			"updated": dateFormatter.string(from: event.updated),
			"updatedBy": event.updatedBy.userID
		]
		
		call(url, httpMethod: .put, parameters: parameters, completion: completion)
	}
	
	class func cancelEvent(_ event: Event, completion: @escaping NetworkCallback) {
		guard let eventId = event.eventID else { return }
		
		let url = baseURL.appending("/events/")
		let parameters: [String: Any] = [
			"eventId": eventId
		]
		
		call(url, httpMethod: .delete, parameters: parameters, completion: completion)
	}
}
