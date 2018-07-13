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
	
	let currentUser = Database().getCurrentUser()
	var user: User?
	var oldPrescription: Prescription?
	var values = [String: Any?]()
	var tagIndex = 0
	var availableExercises = ["Footing", "Natation", "Pompes", "Squats", "Vélo", "Abdominaux"]
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = "prescriptionController_title".localized
		navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(displayData))
		
		if let oldPrescription = oldPrescription {
			values.removeAll()

			for (index, exercise) in oldPrescription.exercises.enumerated() {
				values["exercise-\(index)"] = exercise.name
				addExercise(autoSelect: false, afterButton: true)

				switch exercise.name {
				case "Footing", "Vélo":
					values["duration-\(index)"] = Double(exercise.duration!)
					values["intensity-\(index)"] = exercise.intensity
				case "Pompes", "Abdominaux", "Squats":
					values["repetitions-\(index)"] = Double(exercise.repetitions!)
					values["series-\(index)"] = Double(exercise.series!)
				case "Natation":
					values["duration-\(index)"] = Double(exercise.duration!)
				default:
					continue
				}
				
				// Update tagIndex
				if tagIndex < index {
					tagIndex = index
				}
			}

			form.setValues(values)
		}
		
		guard let currentUser = currentUser else { return }
		
		if currentUser.type == 2 {
			form +++ Section() <<< ButtonRow("addExercise") {
				$0.title = "addExerciseButton".localized
				$0.onCellSelection { [unowned self] _, _ in
					self.addExercise()
				}
			}
		} else {
			for row in form.rows {
				row.baseCell.isUserInteractionEnabled = false
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
			} else {
				Network.displayError(self, from: data)
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
			addSeriesRow(for: &section)
		case "Natation":
			addDurationRow(for: &section)
		default:
			break
		}
		
		section.reload()
	}
	
	private func addIntensityRow(for section: inout Section) {
		guard let exerciseTag = section.first?.tag,
			let index = exerciseTag.split(separator: "-").last else { return }
		
		section <<< AlertRow<Intensity>("intensity-\(index)") {
			$0.title = "exerciseIntensity_title".localized
			$0.options = [.weak, .average, .strong]
			$0.value = values["intensity-\(index)"] as? Intensity
			$0.displayValueFor = { value in
				guard let value = value else { return "" }
				return "\(value.rawValue)"
			}
		}
	}
	
	private func addDurationRow(for section: inout Section) {
		guard let exerciseTag = section.first?.tag,
			let index = exerciseTag.split(separator: "-").last else { return }
		
		section <<< DecimalRow("duration-\(index)") {
			$0.title = "exerciseDuration_title".localized
			
			if let value = values["duration-\(index)"] as? Int {
				$0.value = Double(value)
			}
		}
	}
	
	private func addRepetitionsRow(for section: inout Section) {
		guard let exerciseTag = section.first?.tag,
			let index = exerciseTag.split(separator: "-").last else { return }
		
		section <<< DecimalRow("repetitions-\(index)") {
			$0.title = "exerciseRepetitions_title".localized
			
			if let value = values["repetitions-\(index)"] as? Int {
				$0.value = Double(value)
			}
		}
	}
	
	private func addSeriesRow(for section: inout Section) {
		guard let exerciseTag = section.first?.tag,
			let index = exerciseTag.split(separator: "-").last else { return }
		
		section <<< DecimalRow("series-\(index)") {
			$0.title = "exerciseSeries_title".localized
			
			if let value = values["series-\(index)"] as? Int {
				$0.value = Double(value)
			}
		}
	}
	
	@discardableResult private func addExercise(autoSelect: Bool = true, afterButton: Bool = false) -> Section {
		let section = Section()
		var insertIndex = form.count
		
		if !afterButton {
			insertIndex -= 1
		}
		
		let row = PushRow<String>("exercise-\(tagIndex)") {
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
			
			$0.trailingSwipe.performsFirstActionWithFullSwipe = false
			
			let action = SwipeAction(style: .normal, title: "Delete") { [weak self] _, row, handler in
				guard let row = row as? PushRow<String>,
					let section = row.section,
					let index = section.index else { handler?(false); return }
				
				// Re-insert the exercise in the list
				if let value = row.value {
					self?.availableExercises.append(value)
				}
				
				// Delete section
				self?.form.remove(at: index)
				
				handler?(true)
			}
			
			action.backgroundColor = .red
			
			$0.trailingSwipe.actions.append(action)

		}
		
		section <<< row
		
		form.insert(section, at: insertIndex)
		
		if autoSelect {
			row.didSelect()
		}
		
		tagIndex += 1
		return section
	}
	
	private func unserialize(_ data: Data) -> Int? {
		guard let unserializedJSON = try? JSONSerialization.jsonObject(with: data, options: []) else { return nil }
		guard let json = unserializedJSON as? [String: Int] else { return nil }
		
		guard let prescriptionId = json["id"] else { return nil }
		
		return prescriptionId
	}
}
