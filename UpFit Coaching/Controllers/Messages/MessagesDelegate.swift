//
//  MessagesDelegate.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 21/04/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import Starscream
import UserNotifications

class MessagesDelegate {
	
	enum MessageDisplayMode {
		case display, hide
	}
	
	static var instance = MessagesDelegate()
	
	var socket: WebSocket?
	var displayMode = MessageDisplayMode.display
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
//		// Create a local notification
//		let content = UNMutableNotificationContent()
//		content.title = "\(message.sender.firstName) \(message.sender.lastName)"
//		content.body = message.content
//		content.sound = UNNotificationSound.default()
//
//		// Add the notification to the queue, for immediate firing
//		let request = UNNotificationRequest(identifier: "message", content: content, trigger: nil)
//		UNUserNotificationCenter.current().add(request)
	}
	
	class func decode(from text: String) -> Message? {
		print(text)
		
		// Setting up JSON decoder
		let decoder = JSONDecoder.withDate
		
		// Decode JSON message
		guard let json = text.data(using: .utf8) else { print("MessagesDelegate", "text to data error"); return nil }
		guard let message = try? decoder.decode(Message.self, from: json) else { print("MessagesDelegate", "data to class error"); return nil }
		
		return message
	}
}
