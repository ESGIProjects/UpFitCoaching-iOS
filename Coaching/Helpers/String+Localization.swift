//
//  String+Localization.swift
//  Coaching
//
//  Created by Jason Pierna on 10/03/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import Foundation

extension String {
	var localized: String {
		return NSLocalizedString(self, comment: "")
	}
	
	func localized(with arguments: CVarArg...) -> String {
		return String(format: localized, arguments: arguments)
	}
}
