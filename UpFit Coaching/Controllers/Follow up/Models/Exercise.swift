//
//  Exercise.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 03/07/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import Foundation
import RealmSwift

final class ExerciseObject: Object {
	@objc dynamic var name = ""
	var duration = RealmOptional<Int>()
	var intensity = RealmOptional<Int>()
	var repetitions = RealmOptional<Int>()
	var series = RealmOptional<Int>()
	
	convenience init(exercise: Exercise) {
		self.init()
		
		name = exercise.name
		duration.value = exercise.duration
		
		if let intensity = exercise.intensity {
			self.intensity.value = intensity.rawValue
		}
		
		repetitions.value = exercise.repetitions
		series.value = exercise.series
	}
}

enum Intensity: Int, Codable {
	case weak, average, strong
}

class Exercise: NSObject, Codable {
	enum CodingKeys: String, CodingKey {
		case name = "exercise", duration, intensity, repetitions, series
	}
	
	var name: String
	var duration: Int?
	var intensity: Intensity?
	var repetitions: Int?
	var series: Int?
	
	init(name: String, duration: Int? = nil, intensity: Intensity? = nil, repetitions: Int? = nil, series: Int? = nil) {
		self.name = name
		self.duration = duration
		self.intensity = intensity
		self.repetitions = repetitions
		self.series = series
	}
	
	init(object: ExerciseObject) {
		name = object.name
		duration = object.duration.value
		
		if let intensity = object.intensity.value {
			self.intensity = Intensity(rawValue: intensity)
		}
		
		repetitions = object.repetitions.value
		series = object.series.value
	}
	
	// Exercises' list
	
	static func footing(duration: Int, intensity: Intensity) -> Exercise {
		return Exercise(name: "Footing", duration: duration, intensity: intensity)
	}
	
	static func swimming(duration: Int) -> Exercise {
		return Exercise(name: "Natation", duration: duration)
	}
	
	static func pushUp(repetitions: Int, series: Int) -> Exercise {
		return Exercise(name: "Pompes", repetitions: repetitions, series: series)
	}
	
	static func squats(repetitions: Int, series: Int) -> Exercise {
		return Exercise(name: "Squats", repetitions: repetitions, series: series)
	}
	
	static func cycling(duration: Int, intensity: Intensity) -> Exercise {
		return Exercise(name: "Vélo", duration: duration, intensity: intensity)
	}
	
	static func abs(repetitions: Int, series: Int) -> Exercise {
		return Exercise(name: "Abdominaux", repetitions: repetitions, series: series)
	}
}
