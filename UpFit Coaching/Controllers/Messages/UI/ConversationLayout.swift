//
//  ConversationLayout.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 10/03/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
// Version 1.0

import UIKit

protocol ConversationLayoutDelegate: class {
	func collectionView(_ collectionView: UICollectionView, isMessageFromUserFor indexPath: IndexPath) -> Bool
	func collectionView(_ collectionView: UICollectionView, textAt indexPath: IndexPath) -> String
	func collectionView(_ collectionView: UICollectionView, fontAt indexPath: IndexPath) -> UIFont
}

class ConversationLayout: UICollectionViewLayout {
	
	weak var delegate: ConversationLayoutDelegate?
	
	private var cache = [UICollectionViewLayoutAttributes]()
	
	private var xPadding: CGFloat = 10.0
	private var yPadding: CGFloat = 5.0
	
	private var contentHeight: CGFloat = 0.0
	private var contentWidth: CGFloat {
		guard let collectionView = collectionView else { return 0 }
		
		let insets = collectionView.contentInset
		return collectionView.bounds.width - (insets.left + insets.right)
	}
	
	override var collectionViewContentSize: CGSize {
		return CGSize(width: contentWidth, height: contentHeight)
	}
	
	override func prepare() {		
		guard cache.isEmpty == true, let collectionView = collectionView else { return }
		
		let maxCellWidth = contentWidth * 0.7
		var yPosition: CGFloat = 0.0
		
		// Iterate through every items
		for item in 0 ..< collectionView.numberOfItems(inSection: 0) {
			let indexPath = IndexPath(item: item, section: 0)
			
			// Get info from delegate
			guard let delegate = delegate else { return }
			let isFromUser = delegate.collectionView(collectionView, isMessageFromUserFor: indexPath)
			let text = delegate.collectionView(collectionView, textAt: indexPath)
			let font = delegate.collectionView(collectionView, fontAt: indexPath)
			
			// Determine text area
			let maxRect = CGSize(width: maxCellWidth, height: .greatestFiniteMagnitude)
			let boundingRect = text.boundingRect(with: maxRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
			let textWidth = ceil(boundingRect.width)
			let textHeight = ceil(boundingRect.height)
			
			// Calculate cell frame
			let width = textWidth + xPadding * 4
			let height = textHeight + yPadding * 4
			let xPosition = isFromUser ? contentWidth - width : 0.0
			let frame = CGRect(x: xPosition, y: yPosition, width: width, height: height)
			
			// Set cell attributes
			let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
			attributes.frame = frame.insetBy(dx: xPadding, dy: yPadding)
			cache.append(attributes)
			
			// Update collectionView height
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
