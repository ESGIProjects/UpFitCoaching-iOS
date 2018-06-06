//
//  EventController.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 01/06/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit
import MapKit

class EventController: UIViewController {
	
	var headerTitle: UILabel!
	var clientLabel: UILabel!
	var dateLabel: UILabel!
	var addressLabel: UILabel!
	var mapView: MKMapView!
	var deleteButton: UIBarButtonItem!
	
	var event: Event?
	var currentUser = Database().getCurrentUser()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = "eventController_title".localized
		view.backgroundColor = .white
		setupLayout()
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "editButton".localized, style: .plain, target: self, action: #selector(edit))
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		guard let currentUser = currentUser,
			let event = event else { return }
		
		// Récupération du client si coach
		if currentUser.type == 2 {
			let client = currentUser == event.firstUser ? event.secondUser : event.firstUser
			clientLabel.text = "clientName %@".localized(with: "\(client.firstName) \(client.lastName)")
		}
		
		// Construction de la date
		var dateLabelString: String
		let dateFormatter = DateFormatter()
		
		if Calendar.current.isDate(event.start, inSameDayAs: event.end) {
			dateFormatter.dateFormat = "EEEE d MMMM YYYY"
			let date = dateFormatter.string(from: event.start)
			
			dateFormatter.dateFormat = "HH:mm"
			let startTime = dateFormatter.string(from: event.start)
			let endTime = dateFormatter.string(from: event.end)
			
			dateLabelString = "eventDate_simple %@ %@ %@".localized(with: date, startTime, endTime)
		} else {
			dateFormatter.dateFormat = "EEEE d MMMM YYYY"
			let startDate = dateFormatter.string(from: event.start)
			let endDate = dateFormatter.string(from: event.end)
			
			dateFormatter.dateFormat = "HH:mm"
			let startTime = dateFormatter.string(from: event.start)
			let endTime = dateFormatter.string(from: event.end)
			
			dateLabelString = "eventDate_multiple %@ %@ %@ %@".localized(with: startDate, startTime, endDate, endTime)
		}
		
		headerTitle.text = event.name
		dateLabel.text = dateLabelString
		addressLabel.text = event.firstUser.address ?? event.secondUser.address
	}
	
	@objc func tap() {
		print("Map tapped")
	}
	
	@objc func edit() {
		let addEventController = EditEventController()
		addEventController.editionMode = .edit
		addEventController.event = event
		
		present(UINavigationController(rootViewController: addEventController), animated: true)
	}
}
