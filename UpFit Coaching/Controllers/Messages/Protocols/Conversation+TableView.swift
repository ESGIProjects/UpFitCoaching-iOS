//
//  Conversation+TableView.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 10/05/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit

extension ConversationController: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return messages.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MessageCell", for: indexPath) as? MessageCell else {
			return UICollectionViewCell()
		}
		
		guard let currentUser = currentUser else { return cell }
		
		let message = messages[indexPath.item]
		
		cell.messageLabel.text = message.content
		
		if message.sender != currentUser {
			cell.messageLabel.textColor = .messageReceivedText
			cell.contentView.backgroundColor = .messageReceivedBackground
		} else {
			cell.messageLabel.textColor = .messageSentText
			cell.contentView.backgroundColor = .messageSentBackground
		}
		
		return cell
	}
}

extension ConversationController: ConversationLayoutDelegate {
	func collectionView(_ collectionView: UICollectionView, isMessageFromUserFor indexPath: IndexPath) -> Bool {
		guard let currentUser = currentUser else { return false }
		
		let message = messages[indexPath.item]
		return message.sender == currentUser
	}
	
	func collectionView(_ collectionView: UICollectionView, textAt indexPath: IndexPath) -> String {
		return messages[indexPath.item].content
	}
	
	func collectionView(_ collectionView: UICollectionView, fontAt indexPath: IndexPath) -> UIFont {
		return UIFont.systemFont(ofSize: 17)
	}
}
