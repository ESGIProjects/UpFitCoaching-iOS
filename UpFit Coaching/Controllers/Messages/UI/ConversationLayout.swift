//
//  ConversationLayout.swift
//  Coaching
//
//  Created by Jason Pierna on 10/03/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit

protocol ConversationLayoutDelegate: class {
	func collectionView(_ collectionView: UICollectionView, isMessageFromUserFor indexPath: IndexPath) -> Bool
	func collectionView(_ collectionView: UICollectionView, textAt indexPath: IndexPath) -> String
	func collectionView(_ collectionView: UICollectionView, fontAt indexPath: IndexPath) -> UIFont
}

class ConversationLayout: UICollectionViewLayout {
	
	weak var delegate: ConversationLayoutDelegate!
	
	fileprivate var xPadding: CGFloat = 10
	fileprivate var yPadding: CGFloat = 5
	
	fileprivate var cache = [UICollectionViewLayoutAttributes]()
	
	fileprivate var contentHeight: CGFloat = 0
	fileprivate var contentWidth: CGFloat {
		guard let collectionView = collectionView else {
			return 0
		}
		let insets = collectionView.contentInset
		return collectionView.bounds.width - (insets.left + insets.right)
	}
	
	override var collectionViewContentSize: CGSize {
		return CGSize(width: contentWidth, height: contentHeight)
	}
	
	override func prepare() {		
		guard cache.isEmpty == true, let collectionView = collectionView else {
			return
		}
		
		let maxMessageWidth = contentWidth * 0.7
		var yPosition: CGFloat = 0.0
		
		for item in 0 ..< collectionView.numberOfItems(inSection: 0) {
			let indexPath = IndexPath(item: item, section: 0)
			
			let isFromUser = delegate.collectionView(collectionView, isMessageFromUserFor: indexPath)
			let text = delegate.collectionView(collectionView, textAt: indexPath)
			let font = delegate.collectionView(collectionView, fontAt: indexPath)
			
			// Text size
			let maxRect = CGSize(width: maxMessageWidth, height: .greatestFiniteMagnitude)
			
			let boundingRect = text.boundingRect(with: maxRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
			
			let textWidth = ceil(boundingRect.width)
			let textHeight = ceil(boundingRect.height)
			
			// Bubble
			let width = textWidth + xPadding * 4
			let height = textHeight + yPadding * 4
			let xPosition = isFromUser ? contentWidth - width : 0.0
			let frame = CGRect(x: xPosition, y: yPosition, width: width, height: height)
			
			// Attributes
			let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
			attributes.frame = frame.insetBy(dx: xPadding, dy: yPadding)
			cache.append(attributes)
			
			// Update collection view height
			contentHeight = max(contentHeight, frame.maxY)
			yPosition += height
		}
	}
	
	override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
		return cache.filter { $0.frame.intersects(rect) }
	}
	
	override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
		return cache[indexPath.item]
	}
	
	override func invalidateLayout() {
		cache.removeAll(keepingCapacity: true)
		contentHeight = 0
		super.invalidateLayout()
	}
}
