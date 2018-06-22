//
//  AddMeasurementsController.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 18/06/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit
import Eureka

class AddMeasurementsController: FormViewController {
	var weightRow: DecimalRow!
	var heightRow: DecimalRow!
	var hipCircumferenceRow: DecimalRow!
	var waistCircumferenceRow: DecimalRow!
	var thighCircumferenceRow: DecimalRow!
	var armCircumferenceRow: DecimalRow!
	
	var oldMeasurements: Measurements? // type Measurement?
	
	var client: User?
	var weight: Double!
	var height: Double!
	var hipCircumference: Double!
	var waistCircumference: Double!
	var thighCircumference: Double!
	var armCircumference: Double!
	
	// MARK: - UIViewController
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = "addMeasurementsController_title".localized
		
		if let measurements = oldMeasurements {
			weight = measurements.weight
			height = measurements.height
			hipCircumference = measurements.hipCircumference
			waistCircumference = measurements.waistCircumference
			thighCircumference = measurements.thighCircumference
			armCircumference = measurements.armCircumference
		}
		
		setupLayout()
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "updateButton".localized, style: .done, target: self, action: #selector(update))
		navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
		toggleUpdateButton()
	}
	
	// MARK: - Actions
	
	@objc func update() {
		guard let client = client else { return }
		let measurements = Measurements(user: client, date: Date(), weight: weight, height: height, hipCircumference: hipCircumference, waistCircumference: waistCircumference, thighCircumference: thighCircumference, armCircumference: armCircumference)
	}
	
	@objc func cancel() {
		navigationController?.dismiss(animated: true)
	}
	
	// MARK: - Helpers
	
	func toggleUpdateButton() {
		navigationItem.rightBarButtonItem?.isEnabled = weight != nil && height != nil && hipCircumference != nil
			&& waistCircumference != nil && thighCircumference != nil && armCircumference != nil
	}
}
