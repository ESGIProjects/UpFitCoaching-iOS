//
//  Prescription+UI.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 16/07/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
// Version 1.0

import UIKit
import Eureka

extension PrescriptionController {
	
	// MARK: - Manipulating the form
	
	func buildForm(from prescription: Prescription) {
		values.removeAll()
		
		for (index, exercise) in prescription.exercises.enumerated() {
			values["exercise-\(index)"] = exercise.name
			addExercise(autoSelect: false, afterButton: true)
			
			switch exercise.name {
			case "Footing", "Vélo":
				values["duration-\(index)"] = Double(exercise.duration!) / 60.0
				values["intensity-\(index)"] = exercise.intensity
			case "Pompes", "Abdominaux", "Squats":
				values["repetitions-\(index)"] = Double(exercise.repetitions!)
				values["series-\(index)"] = Double(exercise.series!)
			case "Natation":
				values["duration-\(index)"] = Double(exercise.duration!) / 60.0
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
	
	func setAddButton() {
		form +++ Section() <<< ButtonRow("addExercise") {
			$0.title = "addExerciseButton".localized
			$0.cellUpdate { cell, _ in
				cell.textLabel?.textColor = UIColor(red: 12.0/255.0, green: 200.0/255.0, blue: 165.0/255.0, alpha: 1.0)
			}
			$0.onCellSelection { [unowned self] _, _ in
				if self.availableExercises.count > 0 {
					self.addExercise()
				} else {
					self.presentAlert(title: "noMoreAvailableExercises_title".localized, message: "noMoreAvailableExercises_message".localized)
				}
			}
		}
	}
	
	// MARK: - Manipulating helpers
	
	func loadSection(_ section: inout Section, for exercise: String) {
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
	
	func createExerciseRow() -> PushRow<String> {
		return PushRow<String>("exercise-\(tagIndex)") {
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
	}
	
	func addIntensityRow(for section: inout Section) {
		guard let exerciseTag = section.first?.tag,
			let index = exerciseTag.split(separator: "-").last else { return }
		
		section <<< AlertRow<Intensity>("intensity-\(index)") {
			$0.title = "exerciseIntensity_title".localized
			$0.options = [.weak, .average, .strong]
			$0.value = values["intensity-\(index)"] as? Intensity
			$0.displayValueFor = { value in
				guard let value = value else { return "" }
				switch value {
				case .weak:
					return "intensity_weak".localized
				case .average:
					return "intensity_average".localized
				case .strong:
					return "intensity_strong".localized
				}
			}
		}
	}
	
	func addDurationRow(for section: inout Section) {
		guard let exerciseTag = section.first?.tag,
			let index = exerciseTag.split(separator: "-").last else { return }
		
		section <<< DecimalRow("duration-\(index)") {
			$0.title = "exerciseDuration_title".localized
			$0.placeholder = "exerciseDuration_placeholder".localized
			
			let formatter = NumberFormatter()
			formatter.maximumFractionDigits = 0
			
			$0.formatter = formatter
			$0.useFormatterDuringInput = true
			
			if let value = values["duration-\(index)"] as? Int {
				$0.value = Double(value)
			}
		}
	}
	
	func addRepetitionsRow(for section: inout Section) {
		guard let exerciseTag = section.first?.tag,
			let index = exerciseTag.split(separator: "-").last else { return }
		
		section <<< DecimalRow("repetitions-\(index)") {
			$0.title = "exerciseRepetitions_title".localized
			
			let formatter = NumberFormatter()
			formatter.maximumFractionDigits = 0
			
			$0.formatter = formatter
			$0.useFormatterDuringInput = true
			
			if let value = values["repetitions-\(index)"] as? Int {
				$0.value = Double(value)
			}
		}
	}
	
	func addSeriesRow(for section: inout Section) {
		guard let exerciseTag = section.first?.tag,
			let index = exerciseTag.split(separator: "-").last else { return }
		
		section <<< DecimalRow("series-\(index)") {
			$0.title = "exerciseSeries_title".localized
			
			let formatter = NumberFormatter()
			formatter.maximumFractionDigits = 0
			
			$0.formatter = formatter
			$0.useFormatterDuringInput = true
			
			if let value = values["series-\(index)"] as? Int {
				$0.value = Double(value)
			}
		}
	}
}
