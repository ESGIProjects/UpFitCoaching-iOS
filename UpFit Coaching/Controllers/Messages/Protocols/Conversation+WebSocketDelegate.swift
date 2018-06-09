//
//  Conversation+WebSocketDelegate.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 10/05/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import Foundation
import Starscream

extension ConversationController: WebSocketDelegate {
	func websocketDidConnect(socket: WebSocketClient) {
		MessagesDelegate.instance.websocketDidConnect(socket: socket)
	}
	
	func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
		MessagesDelegate.instance.websocketDidDisconnect(socket: socket, error: error)
	}
	
	func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
		guard let message = MessagesDelegate.decode(from: text) else { return }
		
		Database().createOrUpdate(model: message, with: MessageObject.init)
		
		guard let otherUser = otherUser else { return }
		
		if message.sender == otherUser {
			messages.append(message)
			
			DispatchQueue.main.async { [weak self] in
				self?.collectionView.reloadData()
				self?.scrollToBottom(animated: true)
			}
		}
	}
	
	func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
		MessagesDelegate.instance.websocketDidReceiveData(socket: socket, data: data)
	}
}
