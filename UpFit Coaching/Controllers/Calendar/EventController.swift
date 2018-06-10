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
	
	var address: String?
	var annotation: MKPointAnnotation?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = "eventController_title".localized
		view.backgroundColor = .white
		setupLayout()
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "editButton".localized, style: .plain, target: self, action: #selector(edit))
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		navigationController?.isToolbarHidden = false
		
		guard let currentUser = currentUser,
			let event = event else { return }
		
		// If coach, retrieve client
		if currentUser.type == 2 {
			let client = currentUser == event.firstUser ? event.secondUser : event.firstUser
			clientLabel.text = "clientName %@".localized(with: "\(client.firstName) \(client.lastName)")
		}
		
		// Get address
		address = event.firstUser.address ?? event.secondUser.address
		
		// Build dates
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
		
		// Set labels text
		headerTitle.text = event.name
		dateLabel.text = dateLabelString
		addressLabel.text = address
		
		setupMapKit()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		navigationController?.isToolbarHidden = true
	}
	
	// MARK: - Helpers
	
	func setupMapKit() {
		guard let address = address else {
			mapView.isHidden = true
			return
		}
		
		mapView.isHidden = false
		
		CLGeocoder().geocodeAddressString(address) { [weak self] placemarks, error in
			guard let mapView = self?.mapView else { return }
			
			if let error = error {
				print(error.localizedDescription)
				mapView.isHidden = true
			} else {
				guard let topResult = placemarks?.first else { return }
				guard let coordinates = topResult.location?.coordinate else { return }
				
				let pointAnnotation = MKPointAnnotation()
				pointAnnotation.coordinate = coordinates
				pointAnnotation.title = self?.event?.name
				
				let region = MKCoordinateRegionMakeWithDistance(coordinates, 3000, 3000)
				
				mapView.setRegion(region, animated: false)
				mapView.addAnnotation(pointAnnotation)
				
				self?.annotation = pointAnnotation
			}
		}
	}
	
	// MARK: - Actions
	
	@objc func tap() {
		guard let annotation = annotation else { return }
		
		let placemark = MKPlacemark(coordinate: annotation.coordinate)
		let item = MKMapItem(placemark: placemark)
		item.name = annotation.title
		
		item.openInMaps(launchOptions: [
			MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDefault
			])
	}
	
	@objc func edit() {
		let addEventController = EditEventController()
		addEventController.editionMode = .edit
		addEventController.event = event
		
		present(UINavigationController(rootViewController: addEventController), animated: true)
	}
	
	@objc func cancel() {
		guard let eventID = event?.eventID else { return }
		
		let alertController = UIAlertController(title: "cancelEventButton".localized, message: "cancelEvent_message".localized, preferredStyle: .alert)
		alertController.addAction(UIAlertAction(title: "noButton".localized, style: .cancel))
		alertController.addAction(UIAlertAction(title: "yesButton".localized, style: .destructive, handler: { [weak self] _ in
			// Network…
			Database().delete(type: EventObject.self, with: eventID)
			self?.navigationController?.popViewController(animated: true)
		}))
		
		present(alertController, animated: true)
	}
}
