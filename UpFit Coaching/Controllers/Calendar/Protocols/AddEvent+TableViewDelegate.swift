//
//  AddEvent+TableViewDelegate.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 09/05/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit

extension AddEventController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		
		if indexPath == startIndexPath {
			currentPicker = currentPicker == .start ? .none : .start
			startValueLabel.textColor = currentPicker == .start ? .red : .black
			endValueLabel.textColor = .black
		} else if indexPath == endIndexPath {
			currentPicker = currentPicker == .end ? .none : .end
			startValueLabel.textColor = .black
			endValueLabel.textColor = currentPicker == .end ? .red : .black
		}
	}
	
	func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
		return indexPath == startIndexPath || indexPath == endIndexPath
	}
}
