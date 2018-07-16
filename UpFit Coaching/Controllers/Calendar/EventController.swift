//
//  EventController.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 01/06/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
// Version 1.0

import UIKit
import MapKit
import PKHUD

class EventController: UIViewController {
	
	var headerTitle: UILabel!
	var typeLabel: UILabel!
	var dateLabel: UILabel!
	var addressLabel: UILabel!
	var mapView: MKMapView!
	var deleteButton: UIBarButtonItem!
	
	var event: Event?
	var currentUser = Database().getCurrentUser()	
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
		
		typeLabel.text = event.type == 0 ? "eventType_appraisal".localized : "eventType_session".localized
		
		// If coach, retrieve client
		if currentUser.type == 2 {
			let client = currentUser == event.firstUser ? event.secondUser : event.firstUser
			typeLabel.text?.append("clientName".localized(with: "\(client.firstName) \(client.lastName)"))
		} else {
			
		}
		
		// Build dates
		var dateLabelString: String
		let dateFormatter = DateFormatter()
		
		if Calendar.current.isDate(event.start, inSameDayAs: event.end) {
			dateFormatter.dateFormat = "EEEE d MMMM YYYY"
			let date = dateFormatter.string(from: event.start)
			
			dateFormatter.dateFormat = "HH:mm"
			let startTime = dateFormatter.string(from: event.start)
			let endTime = dateFormatter.string(from: event.end)
			
			dateLabelString = "eventDate_simple".localized(with: date, startTime, endTime)
		} else {
			dateFormatter.dateFormat = "EEEE d MMMM YYYY"
			let startDate = dateFormatter.string(from: event.start)
			let endDate = dateFormatter.string(from: event.end)
			
			dateFormatter.dateFormat = "HH:mm"
			let startTime = dateFormatter.string(from: event.start)
			let endTime = dateFormatter.string(from: event.end)
			
			dateLabelString = "eventDate_multiple".localized(with: startDate, startTime, endDate, endTime)
		}
		
		// Set labels text
		headerTitle.text = event.name
		dateLabel.text = dateLabelString
		addressLabel.text = event.address(.twoLines)
		
		setupMapKit()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		navigationController?.isToolbarHidden = true
	}
	
	// MARK: - Helpers
	
	func setupMapKit() {
		guard let address = event?.address() else {
			mapView.isHidden = true
			return
		}
		
		CLGeocoder().geocodeAddressString(address) { [weak self] placemarks, error in
			guard let mapView = self?.mapView else { return }
			
			if let error = error {
				print(error.localizedDescription)
				mapView.isHidden = true
			} else {
				mapView.isHidden = false
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
		guard let event = event,
			let eventID = event.eventID else { return }
		
		let alertController = UIAlertController(title: "cancelEventButton".localized, message: "cancelEvent_message".localized, preferredStyle: .alert)
		alertController.addAction(UIAlertAction(title: "noButton".localized, style: .cancel))
		alertController.addAction(UIAlertAction(title: "yesButton".localized, style: .destructive, handler: { [weak self] _ in
			
			Network.cancelEvent(event) { data, response, _ in
				DispatchQueue.main.async {
					HUD.show(.progress)
				}
				
				if Network.isSuccess(response: response, successCode: 200) {
					Database().delete(type: EventObject.self, with: eventID)
					
					DispatchQueue.main.async {
						self?.navigationController?.popViewController(animated: true)
					}					
				} else {
					guard let data = data else { return }
					Network.displayError(self, from: data)
				}
				
				DispatchQueue.main.async {
					HUD.hide()
				}
			}
		}))
		
		present(alertController, animated: true)
	}
}
