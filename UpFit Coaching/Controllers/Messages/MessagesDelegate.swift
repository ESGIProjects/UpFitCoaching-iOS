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
			socket?.delegate = newValue ?? self
		}
	}
	
	private var userInitiatedDisconnect = false
	
	private init() {
		guard let userID = UserDefaults.standard.object(forKey: "userID") as? Int else { return }
		guard let authToken = UserDefaults.standard.object(forKey: "authToken") as? String else { return }
		guard let url = URL(string: "ws://212.47.234.147/ws?id=\(userID)") else { return }
		
		var request = URLRequest(url: url)
		request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
		
		socket = WebSocket(request: request)
		socket?.delegate = self
		
		// Observers
		NotificationCenter.default.addObserver(self, selector: #selector(disconnect), name: .UIApplicationWillResignActive, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(connect), name: .UIApplicationDidBecomeActive, object: nil)
	}
	
	deinit {
		NotificationCenter.default.removeObserver(self, name: .UIApplicationWillResignActive, object: nil)
		NotificationCenter.default.removeObserver(self, name: .UIApplicationDidBecomeActive, object: nil)
	}
	
	@objc func connect() {
		userInitiatedDisconnect = false
		socket?.connect()
	}
	
	@objc func disconnect() {
		userInitiatedDisconnect = true
		socket?.disconnect()
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

extension MessagesDelegate: WebSocketDelegate {
	func websocketDidConnect(socket: WebSocketClient) {
		print(#function)
	}
	
	func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
		print(#function, error?.localizedDescription ?? "")
		
		if !userInitiatedDisconnect {
			Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] timer in
				if !socket.isConnected {
					self?.connect()
					timer.invalidate()
				}
			}
		}
	}
	
	func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
		print(#function)
		
		guard let message = MessagesDelegate.decode(from: text), message.messageID != nil else { return }
		
		// Save message
		Database().createOrUpdate(model: message, with: MessageObject.init)
	}
	
	func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
		print(#function)
	}
}
