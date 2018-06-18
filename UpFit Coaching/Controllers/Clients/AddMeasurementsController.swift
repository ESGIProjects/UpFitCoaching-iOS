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
	
	var oldMeasurement: Int? // type Measurement?
	
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
		
		if let measurement = oldMeasurement {
			weight = 0.0
			height = 0.0
			hipCircumference = 0.0
			waistCircumference = 0.0
			thighCircumference = 0.0
			armCircumference = 0.0
		} else {
			weight = 0.0
			height = 0.0
			hipCircumference = 0.0
			waistCircumference = 0.0
			thighCircumference = 0.0
			armCircumference = 0.0
		}
		
		setupLayout()
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "updateButton".localized, style: .done, target: self, action: #selector(update))
		navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
		toggleUpdateButton()
	}
	
	// MARK: - Actions
	
	@objc func update() {
		
	}
	
	@objc func cancel() {
		
	}
	
	// MARK: - Helpers
	
	func toggleUpdateButton() {
		
	}
}
