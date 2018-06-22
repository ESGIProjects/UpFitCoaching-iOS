//
//  Event+UI.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 06/06/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit
import MapKit

extension EventController {
	class UI {
		class func headerTitle() -> UILabel {
			let label = UILabel()
			label.translatesAutoresizingMaskIntoConstraints = false
			
			label.font = UIFont.preferredFont(forTextStyle: .title1)
			label.numberOfLines = 0
			
			return label
		}
		
		class func typeLabel() -> UILabel {
			let label = UILabel()
			label.translatesAutoresizingMaskIntoConstraints = false
			
			label.font = UIFont.preferredFont(forTextStyle: .headline)
			label.numberOfLines = 0
			
			return label
		}
		
		class func dateLabel() -> UILabel {
			let label = UILabel()
			label.translatesAutoresizingMaskIntoConstraints = false
			
			label.font = UIFont.preferredFont(forTextStyle: .headline)
			label.textColor = .gray
			label.numberOfLines = 0
			
			return label
		}
		
		class func addressLabel() -> UILabel {
			let label = UILabel()
			label.translatesAutoresizingMaskIntoConstraints = false
			
			label.font = UIFont.preferredFont(forTextStyle: .body)
			label.textColor = .gray
			label.numberOfLines = 0
			
			return label
		}
		
		class func mapView() -> MKMapView {
			let view = MKMapView(frame: .zero)
			view.translatesAutoresizingMaskIntoConstraints = false
			
			view.layer.borderColor = UIColor.lightGray.cgColor
			view.layer.borderWidth = 1.0
			view.layer.cornerRadius = 5.0
			view.layer.masksToBounds = true
			
			view.isScrollEnabled = false
			view.isZoomEnabled = false
			
			view.isHidden = true
			
			return view
		}
		
		class func deleteButton() -> UIBarButtonItem {
			let button = UIBarButtonItem(title: "cancelEventButton".localized, style: .plain, target: nil, action: nil)
			button.tintColor = .red
			
			return button
		}
	}
	
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
		headerTitle = UI.headerTitle()
		dateLabel = UI.dateLabel()
		addressLabel = UI.addressLabel()
		mapView = UI.mapView()
		
		deleteButton = UI.deleteButton()
		deleteButton.target = self
		deleteButton.action = #selector(cancel)
		
		typeLabel = UI.typeLabel()
		
		let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap))
		mapView.addGestureRecognizer(tapGestureRecognizer)
				
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
