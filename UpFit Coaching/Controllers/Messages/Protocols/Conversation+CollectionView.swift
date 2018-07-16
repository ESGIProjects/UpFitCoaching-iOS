//
//  Conversation+CollectionView.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 10/05/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
// Version 1.0

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
			cell.contentView.backgroundColor = UIColor(red: 12.0/255.0, green: 200.0/255.0, blue: 165.0/255.0, alpha: 1.0)
		} else {
			cell.contentView.backgroundColor = UIColor(red: 200.0/255.0, green: 200.0/255.0, blue: 200.0/255.0, alpha: 1.0)
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
