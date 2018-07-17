//
//  PrescriptionController.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 03/07/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
// Version 1.0

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
		
		if #available(iOS 11.0, *) {
			navigationItem.largeTitleDisplayMode = .never
		}
		
		if let oldPrescription = oldPrescription {
			buildForm(from: oldPrescription)
		}
		
		guard let currentUser = currentUser else { return }
		
		if currentUser.type == 2 {
			title = "prescriptionController_title_new".localized
			navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
			navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(postData))
			
			setAddButton()
		} else {
			title = "prescriptionController_title".localized
			
			for row in form.rows {
				row.baseCell.isUserInteractionEnabled = false
			}
		}
	}
	
	// MARK: - Actions
	
	@objc func postData() {
		guard let user = user else { return }
		
		// Create prescription
		let prescription = Prescription(user: user, date: Date(), exercises: getExercises())
		
		guard prescription.exercises.count > 0 else {
			self.presentAlert(title: "error".localized, message: "prescription_noExerciseError".localized)
			return
		}
		
		DispatchQueue.main.async {
			HUD.show(.progress)
		}
		
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
				
				exercises.append(Exercise(name: exerciseName, duration: Int(duration) * 60, intensity: intensity))
				
			case "Pompes", "Abdominaux", "Squats":
				guard let repetitions = (values["repetitions-\(index)"] as? Double?) as? Double,
					let series = (values["series-\(index)"] as? Double?) as? Double else { continue }
				
				exercises.append(Exercise(name: exerciseName, repetitions: Int(repetitions), series: Int(series)))
				
			case "Natation":
				guard let duration = (values["duration-\(index)"] as? Double?) as? Double else { continue }
				
				exercises.append(Exercise.swimming(duration: Int(duration) * 60))
				
			default:
				continue
			}
		}
		
		return exercises
	}
	
	// MARK: - UI Helpers
	
	@discardableResult func addExercise(autoSelect: Bool = true, afterButton: Bool = false) -> Section {
		let section = Section()
		var insertIndex = form.count
		
		if !afterButton {
			insertIndex -= 1
		}
		
		// Creating the row
		let row = createExerciseRow()
		section <<< row
		
		// Inserting the row
		form.insert(section, at: insertIndex)
		
		// Presents the exercise choice right away
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
