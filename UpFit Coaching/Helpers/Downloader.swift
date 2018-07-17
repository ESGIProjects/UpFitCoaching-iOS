//
//  Downloader.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 25/06/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
// Version 1.0

import Foundation
import PKHUD

class Downloader {
	class func messages(for user: User, in dispatchGroup: DispatchGroup? = nil) {
		dispatchGroup?.enter()
		
		Network.getMessages(for: user) { data, response, _ in
			guard let data = data else { dispatchGroup?.leave(); return }
			
			if Network.isSuccess(response: response, successCode: 200) {
				// Decode messages list
				let decoder = JSONDecoder.withDate
				guard let messages = try? decoder.decode([Message].self, from: data) else { dispatchGroup?.leave(); return }
				
				// Save messages
				let database = Database()
				database.deleteAll(of: MessageObject.self)
				database.createOrUpdate(models: messages, with: MessageObject.init)
				
				// Post a notification telling it's done
				NotificationCenter.default.post(name: .messagesDownloaded, object: nil, userInfo: nil)
				dispatchGroup?.leave()
			}
		}
	}
	
	class func events(for user: User, in dispatchGroup: DispatchGroup? = nil, displaysHUD: Bool = false) {
		dispatchGroup?.enter()
		
		Network.getEvents(for: user) { data, response, _ in
			guard let data = data else { dispatchGroup?.leave(); return }
			
			if Network.isSuccess(response: response, successCode: 200) {
				// Decode events list
				let decoder = JSONDecoder.withDate
				guard let events = try? decoder.decode([Event].self, from: data) else { dispatchGroup?.leave(); return }
				
				// Save events
				let database = Database()
				database.deleteAll(of: EventObject.self)
				database.createOrUpdate(models: events, with: EventObject.init)
				
				// Post a notification telling its done
				NotificationCenter.default.post(name: .eventsDownloaded, object: nil)
				dispatchGroup?.leave()
			}
		}
	}
	
	class func threads(in dispatchGroup: DispatchGroup? = nil, displaysHUD: Bool = false) {
		dispatchGroup?.enter()
		
		Network.getThreads(for: ForumController.forumID) { data, response, _ in
			guard let data = data else { dispatchGroup?.leave(); return }
			
			if Network.isSuccess(response: response, successCode: 200) {
				// Decode thread list
				let decoder = JSONDecoder.withDate
				guard let threads = try? decoder.decode([ForumThread].self, from: data) else { dispatchGroup?.leave(); return }
				
				// Save threads
				let database = Database()
				database.deleteAll(of: ForumThreadObject.self)
				database.createOrUpdate(models: threads, with: ForumThreadObject.init)
				
				// Post a notification telling its done
				NotificationCenter.default.post(name: .threadsDownloaded, object: nil)
				dispatchGroup?.leave()
			}
		}
	}
	
	class func posts(for thread: ForumThread, in dispatchGroup: DispatchGroup? = nil) {
		dispatchGroup?.enter()
		
		Network.getPosts(for: thread) { data, response, _ in
			guard let data = data else { dispatchGroup?.leave(); return }
			
			if Network.isSuccess(response: response, successCode: 200) {
				// Decode post list
				let decoder = JSONDecoder.withDate
				guard let posts = try? decoder.decode([Post].self, from: data) else { dispatchGroup?.leave(); return }
				
				// Save posts
				let database = Database()
				database.deleteAll(of: PostObject.self)
				database.createOrUpdate(models: posts, with: PostObject.init)
				
				// Post a notification telling its done
				NotificationCenter.default.post(name: .postsDownloaded, object: nil)
				dispatchGroup?.leave()
			}
		}
	}
	
	class func appraisal(for user: User, in dispatchGroup: DispatchGroup? = nil) {
		dispatchGroup?.enter()

		Network.getLastAppraisal(for: user) { data, response, _ in
			guard let data = data else { dispatchGroup?.leave(); return }
			
			if Network.isSuccess(response: response, successCode: 200) {
				// Setting up JSON Decoder
				let decoder = JSONDecoder.withDate
				
				// Decode appraisal
				guard let appraisal = try? decoder.decode(Appraisal.self, from: data) else { dispatchGroup?.leave(); return }
				
				// Save appraisal
				Database().createOrUpdate(model: appraisal, with: AppraisalObject.init)
			}
			dispatchGroup?.leave()
		}
	}
	
	class func measurements(for user: User, in dispatchGroup: DispatchGroup? = nil) {
		dispatchGroup?.enter()
		
		Network.getMeasurements(for: user) { data, response, _ in
			guard let data = data else { dispatchGroup?.leave(); return }
			
			if Network.isSuccess(response: response, successCode: 200) {
				// Setting up JSON Decoder
				let decoder = JSONDecoder.withDate
				
				// Decode measurements
				guard let measurements = try? decoder.decode([Measurements].self, from: data) else { dispatchGroup?.leave(); return }
				
				// Save measurements
				Database().createOrUpdate(models: measurements, with: MeasurementsObject.init)
			}
			dispatchGroup?.leave()
		}
	}
	
	class func tests(for client: User, in dispatchGroup: DispatchGroup? = nil) {
		dispatchGroup?.enter()
		
		Network.getTests(for: client) { data, response, _ in
			guard let data = data else { dispatchGroup?.leave(); return }
			
			if Network.isSuccess(response: response, successCode: 200) {
				// Setting up JSON Decoder
				let decoder = JSONDecoder.withDate
				
				// Decode tests
				guard let tests = try? decoder.decode([Test].self, from: data) else { dispatchGroup?.leave(); return }
				
				// Save tests
				Database().createOrUpdate(models: tests, with: TestObject.init)
			}
			dispatchGroup?.leave()
		}
	}
	
	class func prescriptions(for client: User, in dispatchGroup: DispatchGroup? = nil) {
		dispatchGroup?.enter()
		
		Network.getPrescriptions(for: client) { data, response, _ in
			guard let data = data else { dispatchGroup?.leave(); return }
			
			if Network.isSuccess(response: response, successCode: 200) {
				// Setting up JSON Decoder
				let decoder = JSONDecoder.withDate
				
				// Decode prescriptions
				guard let prescriptions = try? decoder.decode([Prescription].self, from: data) else { dispatchGroup?.leave(); return }
				
				// Save prescriptions
				Database().createOrUpdate(models: prescriptions, with: PrescriptionObject.init)
			}
			dispatchGroup?.leave()
		}
	}
}
