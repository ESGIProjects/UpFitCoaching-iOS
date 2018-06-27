//
//  Downloader.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 25/06/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

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
}
