//
//  PrescriptionController.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 03/07/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit
import Eureka

class PrescriptionController: FormViewController {
	var exerciseName: String!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = "prescriptionController_title".localized
		navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
		
		form +++ Section() <<< ButtonRow("addExercise") {
			$0.title = "addExerciseButton".localized
			$0.onCellSelection { [unowned self] _, _ in
				self.addExercise()
			}
		}
		
		addExercise()
	}
	
	@objc func cancel() {
		navigationController?.dismiss(animated: true)
	}
	
	func loadSection(_ section: inout Section, for exercise: String) {
		section.removeLast(section.count - 1)
		
		switch exercise {
		case "Footing", "Vélo":
			addDurationRow(for: &section)
			addIntensityRow(for: &section)
		case "Pompes", "Abdominaux", "Squats":
			addRepetitionsRow(for: &section)
			addSeriessRow(for: &section)
		case "Natation":
			addDurationRow(for: &section)
		default:
			break
		}
	}
	
	func addIntensityRow(for section: inout Section) {
		guard let index = section.index else { return }
		
		section <<< AlertRow<Intensity>("intensity-\(index)") {
			$0.title = "exerciseIntensity_title".localized
			$0.options = [.weak, .average, .strong]
			$0.displayValueFor = { value in
				guard let value = value else { return "" }
				return "\(value.rawValue)"
			}
		}
	}
	
	func addDurationRow(for section: inout Section) {
		guard let index = section.index else { return }
		
		section <<< DecimalRow("duration-\(index)") {
			$0.title = "exerciseDuration_title".localized
		}
	}
	
	func addRepetitionsRow(for section: inout Section) {
		guard let index = section.index else { return }
		
		section <<< DecimalRow("repetitions-\(index)") {
			$0.title = "exerciseRepetitions_title".localized
		}
	}
	
	func addSeriessRow(for section: inout Section) {
		guard let index = section.index else { return }
		
		section <<< DecimalRow("series-\(index)") {
			$0.title = "exerciseSeries_title".localized
		}
	}
	
	func addExercise() {
		form +++ Section()
			<<< PushRow<String>("exercise-\(form.count)") {
			$0.title = "exerciseName_title".localized
			$0.options = ["Footing", "Natation", "Pompes", "Squats", "Vélo", "Abdominaux"]
			$0.value = exerciseName
			$0.onChange { [unowned self] row in
				if let value = row.value, var section = row.section {
					self.exerciseName = value
					self.loadSection(&section, for: value)
				}
			}
		}
	}
}
