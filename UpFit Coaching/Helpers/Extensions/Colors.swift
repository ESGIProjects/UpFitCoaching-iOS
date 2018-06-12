//
//  Colors.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 11/03/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit

extension UIColor {
	// Main colors
	// The app's theme is edited ony through the main colors
	static let background: UIColor						= .white
	static let main: UIColor							= UIColor(red: 22.0/255.0, green: 126.0/255.0, blue: 251.0/255.0, alpha: 1.0)
	static let mainText: UIColor						= .black
	static let secondaryText: UIColor					= .gray
	static let selectedText: UIColor					= .white
	static let disabled: UIColor						= .gray
	static let destructive: UIColor						= .red
	
	// Colors by element
	// Those colors should be defined by the main colors
	static let followUpBMILine: UIColor					= UIColor(red: 244.0/255.0, green: 67.0/255.0, blue: 54.0/255.0, alpha: 1.0)
	static let followUpBFPLine: UIColor					= UIColor(red: 0, green: 150.0/255.0, blue: 136.0/255.0, alpha: 1.0)
	static let followUpWeightLine: UIColor				= UIColor(red: 33.0/255.0, green: 150.0/255.0, blue: 243.0/255.0, alpha: 1.0)
	
	static let messageReceivedBackground: UIColor		= UIColor(red: 229.0/255.0, green: 229.0/255.0, blue: 234.0/255.0, alpha: 1.0)
	static let messageReceivedText: UIColor				= .black
	static let messageSentBackground: UIColor			= UIColor(red: 43.0/255.0, green: 149.0/255.0, blue: 245.0/255.0, alpha: 1.0)
	static let messageSentText: UIColor					= .white
	
	static let calendarMonthBackground: UIColor 		= UIColor(red: 68.0/255.0, green: 207.0/255.0, blue: 212.0/255.0, alpha: 1.0)
	static let calendarMonthText: UIColor				= .selectedText
	static let calendarDaysOutsideOfMonthText: UIColor	= .clear
	static let calendarDaysOfMonthText: UIColor			= .mainText
	static let calendarSelectedDayText: UIColor			= .selectedText
	
	static let threadTitleText: UIColor					= .mainText
	static let threadSubtitleText: UIColor				= .secondaryText
	static let postUsernameText: UIColor				= .main
	static let postContentText: UIColor					= .mainText
	static let postContentDateText: UIColor				= .secondaryText
}
