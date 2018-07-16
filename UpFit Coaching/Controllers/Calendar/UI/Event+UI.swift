//
//  Event+UI.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 06/06/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
// Version 1.0

import UIKit
import MapKit

extension EventController {
	fileprivate func getConstraints() -> [NSLayoutConstraint] {
		let anchors = getAnchors()
		
		return [
			headerTitle.topAnchor.constraint(equalTo: anchors.top, constant: 15.0),
			headerTitle.leadingAnchor.constraint(equalTo: anchors.leading, constant: 15.0),
			headerTitle.trailingAnchor.constraint(equalTo: anchors.trailing, constant: -15.0),
			
			typeLabel.topAnchor.constraint(equalTo: headerTitle.bottomAnchor, constant: 15.0),
			typeLabel.leadingAnchor.constraint(equalTo: anchors.leading, constant: 15.0),
			typeLabel.trailingAnchor.constraint(equalTo: anchors.trailing, constant: -15.0),
			
			dateLabel.topAnchor.constraint(equalTo: typeLabel.bottomAnchor, constant: 15.0),
			dateLabel.leadingAnchor.constraint(equalTo: anchors.leading, constant: 15.0),
			dateLabel.trailingAnchor.constraint(equalTo: anchors.trailing, constant: -15.0),
			
			addressLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 15.0),
			addressLabel.leadingAnchor.constraint(equalTo: anchors.leading, constant: 15.0),
			addressLabel.trailingAnchor.constraint(equalTo: anchors.trailing, constant: -15.0),
			
			mapView.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 15.0),
			mapView.leadingAnchor.constraint(equalTo: anchors.leading, constant: 15.0),
			mapView.trailingAnchor.constraint(equalTo: anchors.trailing, constant: -15.0),
			mapView.heightAnchor.constraint(equalToConstant: 160.0)
		]
	}
	
	fileprivate func setUIComponents() {
		// Labels
		headerTitle = UI.titleLabel
		headerTitle.numberOfLines = 0
		
		typeLabel = UI.headlineLabel
		typeLabel.textColor = .black
		typeLabel.numberOfLines = 0
		
		dateLabel = UI.headlineLabel
		dateLabel.numberOfLines = 0
		
		addressLabel = UI.bodyLabel
		addressLabel.textColor = .gray
		addressLabel.numberOfLines = 0
		
		// Map View
		mapView = UI.eventMap
		
		let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap))
		mapView.addGestureRecognizer(tapGestureRecognizer)
		
		// Toolbar
		deleteButton = UIBarButtonItem(title: "cancelEventButton".localized, style: .done, target: self, action: #selector(cancel))
		deleteButton.tintColor = .red
		
		let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
		toolbarItems = [flexibleSpace, deleteButton, flexibleSpace]
	}
	
	func setupLayout() {
		setUIComponents()
		
		view.addSubview(headerTitle)
		view.addSubview(dateLabel)
		view.addSubview(addressLabel)
		view.addSubview(mapView)
		view.addSubview(typeLabel)
		
		NSLayoutConstraint.activate(getConstraints())
	}
}
