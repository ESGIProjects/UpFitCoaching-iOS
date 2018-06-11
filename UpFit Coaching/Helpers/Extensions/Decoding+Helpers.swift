//
//  Decoding+Helpers.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 19/05/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import Foundation

struct ErrorMessage: Codable {
	var message: String
}

extension DateFormatter {
	static var time: DateFormatter {
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
		
		return formatter
	}
	
	static var date: DateFormatter {
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy-MM-dd"
		
		return formatter
	}
}

extension JSONDecoder {
	static var withDate: JSONDecoder {
		let decoder = JSONDecoder()
		decoder.dateDecodingStrategy = .formatted(.time)
		
		return decoder
	}
}

extension JSONEncoder {
	static var withDate: JSONEncoder {
		let encoder = JSONEncoder()
		encoder.dateEncodingStrategy = .formatted(.time)
		
		return encoder
	}
}
