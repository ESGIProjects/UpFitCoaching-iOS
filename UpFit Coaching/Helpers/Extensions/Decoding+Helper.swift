//
//  Decoding+Helper.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 19/05/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import Foundation

extension DateFormatter {
	static var network: DateFormatter {
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
		
		return formatter
	}
}

extension JSONDecoder {
	static var withDate: JSONDecoder {
		let decoder = JSONDecoder()
		decoder.dateDecodingStrategy = .formatted(.network)
		
		return decoder
	}
}

extension JSONEncoder {
	static var withDate: JSONEncoder {
		let encoder = JSONEncoder()
		encoder.dateEncodingStrategy = .formatted(.network)
		
		return encoder
	}
}
