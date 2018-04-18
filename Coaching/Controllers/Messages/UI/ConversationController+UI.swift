//
//  ConversationController+UI.swift
//  Coaching
//
//  Created by Jason Pierna on 10/03/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit

extension ConversationController {
	class UI {
		class func collectionView(delegate: UICollectionViewDelegate?, dataSource: UICollectionViewDataSource?, layoutDelegate: ConversationLayoutDelegate?) -> UICollectionView {
			let collectionViewLayout = ConversationLayout()
			collectionViewLayout.delegate = layoutDelegate
			
			let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
			collectionView.translatesAutoresizingMaskIntoConstraints = false
			collectionView.backgroundColor = .white
			collectionView.delegate = delegate
			collectionView.dataSource = dataSource
			collectionView.keyboardDismissMode = .onDrag
			return collectionView
		}
		
		class func messageBarView(_ target: Any?, action: Selector) -> MessageBarView {
			let messageBarView = MessageBarView()
			messageBarView.translatesAutoresizingMaskIntoConstraints = false
			
			messageBarView.placeholder = "message_placeholder".localized
			
			messageBarView.button.setTitle("sendMessage_button".localized, for: .normal)
			messageBarView.button.setTitleColor(.main, for: .normal)
			messageBarView.button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17.0)
			messageBarView.button.addTarget(target, action: action, for: .touchUpInside)
			return messageBarView
		}
		
		class func getConstraints(for controller: ConversationController) -> [NSLayoutConstraint] {
			var constraints = [NSLayoutConstraint]()
			
			if #available(iOS 11.0, *) {
				constraints += [
					// Collection view
					controller.collectionView.topAnchor.constraint(equalTo: controller.view.safeAreaLayoutGuide.topAnchor),
					controller.collectionView.bottomAnchor.constraint(equalTo: controller.view.safeAreaLayoutGuide.bottomAnchor),
					controller.collectionView.leadingAnchor.constraint(equalTo: controller.view.safeAreaLayoutGuide.leadingAnchor),
					controller.collectionView.trailingAnchor.constraint(equalTo: controller.view.safeAreaLayoutGuide.trailingAnchor),
					// Message bar view
					controller.messageBarView.leadingAnchor.constraint(equalTo: controller.view.safeAreaLayoutGuide.leadingAnchor),
					controller.messageBarView.trailingAnchor.constraint(equalTo: controller.view.safeAreaLayoutGuide.trailingAnchor)
				]
			} else {
				constraints += [
					// Collection view
					controller.collectionView.topAnchor.constraint(equalTo: controller.view.topAnchor),
					controller.collectionView.bottomAnchor.constraint(equalTo: controller.view.bottomAnchor),
					controller.collectionView.leadingAnchor.constraint(equalTo: controller.view.leadingAnchor),
					controller.collectionView.trailingAnchor.constraint(equalTo: controller.view.trailingAnchor),
					// Message bar view
					controller.messageBarView.leadingAnchor.constraint(equalTo: controller.view.leadingAnchor),
					controller.messageBarView.trailingAnchor.constraint(equalTo: controller.view.trailingAnchor)
				]
			}
			
			return constraints
		}
	}	
}
