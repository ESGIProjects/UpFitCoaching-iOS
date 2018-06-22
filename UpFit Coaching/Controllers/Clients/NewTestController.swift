//
//  NewTestController.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 18/06/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit
import Eureka

class NewTestController: FormViewController {
	var warmUpRow: DecimalRow!
	var startSpeedRow: DecimalRow!
	var increaseRow: DecimalRow!
	var frequencyRow: DecimalRow!
	var kneeFlexibilityRow: AlertRow<Flexibility>!
	var shinFlexibilityRow: AlertRow<Flexibility>!
	var hitFootFlexibilityRow: AlertRow<Flexibility>!
	var closedFistGroundFlexibilityRow: AlertRow<Flexibility>!
	var handFlatGroundFlexibilityRow: AlertRow<Flexibility>!
	
	var client: User?
	var warmUp: Double!
	var startSpeed: Double!
	var increase: Double!
	var frequency: Double!
	var kneeFlexibility: Flexibility!
	var shinFlexibility: Flexibility!
	var hitFootFlexibility: Flexibility!
	var closedFistGroundFlexibility: Flexibility!
	var handFlatGroundFlexibility: Flexibility!
	
	// MARK: - UIViewController
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = "newTestController_title".localized
		setupLayout()
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "addButton".localized, style: .done, target: self, action: #selector(add))
		navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
		toggleAddButton()
	}
	
	// MARK: - Actions
	
	@objc func add() {
		
	}
	
	@objc func cancel() {
		navigationController?.dismiss(animated: true)
	}
	
	// MARK: - Helpers
	
	func toggleAddButton() {
		
	}
}
