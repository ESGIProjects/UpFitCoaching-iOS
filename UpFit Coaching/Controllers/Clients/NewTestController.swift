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
	
	var oldTest: Test?
	
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
		
		if let test = oldTest {
			warmUp = test.warmUp
			startSpeed = test.startSpeed
			increase = test.increase
			frequency = test.frequency
			kneeFlexibility = test.kneeFlexibility
			shinFlexibility = test.shinFlexibility
			hitFootFlexibility = test.hitFootFlexibility
			closedFistGroundFlexibility = test.closedFistGroundFlexibility
			handFlatGroundFlexibility = test.handFlatGroundFlexibility
		}
		
		setupLayout()
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "addButton".localized, style: .done, target: self, action: #selector(add))
		navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
		toggleAddButton()
	}
	
	// MARK: - Actions
	
	@objc func add() {
		guard let client = client else { return }
		let test = Test(user: client, date: Date(), warmUp: warmUp, startSpeed: startSpeed, increase: increase, frequency: frequency, kneeFlexibility: kneeFlexibility, shinFlexibility: shinFlexibility, hitFootFlexibility: hitFootFlexibility, closedFistGroundFlexibility: closedFistGroundFlexibility, handFlatGroundFlexibility: handFlatGroundFlexibility)
		
		// Network & save…
	}
	
	@objc func cancel() {
		navigationController?.dismiss(animated: true)
	}
	
	// MARK: - Helpers
	
	func toggleAddButton() {
		navigationItem.rightBarButtonItem?.isEnabled = warmUp != nil && startSpeed != nil && increase != nil && frequency != nil
			&& kneeFlexibility != nil && shinFlexibility != nil && hitFootFlexibility != nil && closedFistGroundFlexibility != nil
			&& handFlatGroundFlexibility != nil
	}
}
