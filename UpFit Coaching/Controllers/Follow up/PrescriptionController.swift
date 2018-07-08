//
//  PrescriptionController.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 03/07/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit
import Eureka
import PKHUD

class PrescriptionController: FormViewController {
	
	var user: User?
	var oldPrescription: Prescription?
	var availableExercises = ["Footing", "Natation", "Pompes", "Squats", "Vélo", "Abdominaux"]
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = "prescriptionController_title".localized
		navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(displayData))
		
		form +++ Section() <<< ButtonRow("addExercise") {
			$0.title = "addExerciseButton".localized
			$0.onCellSelection { [unowned self] _, _ in
				self.addExercise()
			}
		}
	}
	
	// MARK: - Actions
	
	@objc func displayData() {
		
		DispatchQueue.main.async {
			HUD.show(.progress)
		}
		
		guard let user = user else { return }
		
		// Create prescription
		let prescription = Prescription(user: user, date: Date(), exercises: getExercises())
		
		Network.createPrecription(prescription) { [weak self] data, response, _ in
			guard let data = data else { return }
			
			if Network.isSuccess(response: response, successCode: 201) {
				// Unserialize the prescription ID
				guard let prescriptionID = self?.unserialize(data) else { return }
				prescription.prescriptionID = prescriptionID
				
				// Save prescription
				Database().createOrUpdate(model: prescription, with: PrescriptionObject.init)
				
				// Dismiss controller
				self?.navigationController?.dismiss(animated: true)
			}
			
			DispatchQueue.main.async {
				HUD.hide()
			}
		}
	}
	
	@objc func cancel() {
		navigationController?.dismiss(animated: true)
	}
	
	// MARK: - Data Helpers
	
	private var indexes: [Int] {
		var indexes = [Int]()
		
		form.values().forEach { key, _ in
			if key.contains("exercise-"),
				let indexString = key.split(separator: "-").last,
				let index = Int(indexString) {
				indexes.append(index)
			}
		}
		
		indexes.sort()
		return indexes
	}
	
	private func getExercises() -> [Exercise] {
		var exercises = [Exercise]()
		let values = form.values()
		
		// For each index, create the appropriate exercise if possible
		for index in indexes {
			guard let exerciseName = values["exercise-\(index)"] as? String else { continue }
			
			switch exerciseName {
			case "Footing", "Vélo":
				guard let duration = (values["duration-\(index)"] as? Double?) as? Double,
					let intensity = (values["intensity-\(index)"] as? Intensity?) as? Intensity else { continue }
				
				exercises.append(Exercise(name: exerciseName, duration: Int(duration), intensity: intensity))
				
			case "Pompes", "Abdominaux", "Squats":
				guard let repetitions = (values["repetitions-\(index)"] as? Double?) as? Double,
					let series = (values["series-\(index)"] as? Double?) as? Double else { continue }
				
				exercises.append(Exercise(name: exerciseName, repetitions: Int(repetitions), series: Int(series)))
				
			case "Natation":
				guard let duration = (values["duration-\(index)"] as? Double?) as? Double else { continue }
				
				exercises.append(Exercise.swimming(duration: Int(duration)))
				
			default:
				continue
			}
		}
		
		return exercises
	}
	
	// MARK: - UI Helpers
	
	private func loadSection(_ section: inout Section, for exercise: String) {
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
		
		section.reload()
	}
	
	private func addIntensityRow(for section: inout Section) {
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
	
	private func addDurationRow(for section: inout Section) {
		guard let index = section.index else { return }
		
		section <<< DecimalRow("duration-\(index)") {
			$0.title = "exerciseDuration_title".localized
		}
	}
	
	private func addRepetitionsRow(for section: inout Section) {
		guard let index = section.index else { return }
		
		section <<< DecimalRow("repetitions-\(index)") {
			$0.title = "exerciseRepetitions_title".localized
		}
	}
	
	private func addSeriessRow(for section: inout Section) {
		guard let index = section.index else { return }
		
		section <<< DecimalRow("series-\(index)") {
			$0.title = "exerciseSeries_title".localized
		}
	}
	
	private func addExercise() {
		let section = Section()
		let row = PushRow<String>("exercise-\(form.count - 1)") {
			$0.title = "exerciseName_title".localized
			$0.options = availableExercises
			$0.onChange { [unowned self] row in
				if let value = row.value, var section = row.section {
					self.loadSection(&section, for: value)
					
					if let index = self.availableExercises.index(of: value) {
						self.availableExercises.remove(at: index)
					}
				}
			}
		}
		
		section <<< row
		
		form.insert(section, at: form.count - 1)
		row.didSelect()
	}
	
	private func unserialize(_ data: Data) -> Int? {
		guard let unserializedJSON = try? JSONSerialization.jsonObject(with: data, options: []) else { return nil }
		guard let json = unserializedJSON as? [String: Int] else { return nil }
		
		guard let prescriptionId = json["id"] else { return nil }
		
		return prescriptionId
	}
}
