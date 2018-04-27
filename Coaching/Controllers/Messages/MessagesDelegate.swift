//
//  MessagesDelegate.swift
//  Coaching
//
//  Created by Jason Pierna on 21/04/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import Starscream
import UserNotifications

class MessagesDelegate {
	
	static var instance = MessagesDelegate()
	
	var socket: WebSocket?
	var delegate: WebSocketDelegate? {
		get {
			return socket?.delegate
		}
		set {
			socket?.delegate = newValue
		}
	}
	
	private init() {
		guard let userID = UserDefaults.standard.object(forKey: "userID") as? Int else { return }
		guard let url = URL(string: "ws://212.47.234.147/ws?id=\(userID)") else { return }
		
		socket = WebSocket(url: url)
	}
	
	func connect() {
		socket?.connect()
	}
	
	func disconnect() {
		socket?.disconnect()
	}
	
	class func fireNotification(message: Message) {
		// Create a local notification
		let content = UNMutableNotificationContent()
		content.title = "\(message.sender.firstName) \(message.sender.lastName)"
		content.body = message.content
		content.sound = UNNotificationSound.default()
		
		// Add the notification to the queue, for immediate firing
		let request = UNNotificationRequest(identifier: "message", content: content, trigger: nil)
		UNUserNotificationCenter.current().add(request)
	}
}
