//
//  ConversationList+WebSocket.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 10/05/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import Foundation
import Starscream

extension ConversationListController: WebSocketDelegate {
	func websocketDidConnect(socket: WebSocketClient) {
		MessagesDelegate.instance.websocketDidConnect(socket: socket)
	}
	
	func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
		MessagesDelegate.instance.websocketDidDisconnect(socket: socket, error: error)
	}
	
	func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
		print(#function)
		
		guard let message = MessagesDelegate.decode(from: text), message.messageID != nil else { return }
		
		// Save message
		Database().createOrUpdate(model: message, with: MessageObject.init)
		
		// Regenerate conversation
		conversations.add(message: message)
		
		DispatchQueue.main.async { [weak self] in
			self?.tableView.reloadData()
		}
	}
	
	func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
		MessagesDelegate.instance.websocketDidReceiveData(socket: socket, data: data)
	}
}
