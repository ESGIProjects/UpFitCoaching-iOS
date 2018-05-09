//
//  AddEventTableViewDelegate.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 09/05/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit

class AddEventTableViewDelegate: NSObject, UITableViewDelegate {
	
	var controller: AddEventController
	
	init(for controller: AddEventController) {
		self.controller = controller
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		
//		guard let controller = controller else { return }
		
		if indexPath == controller.startIndexPath {
			controller.currentPicker = controller.currentPicker == .start ? .none : .start
			controller.startValueLabel.textColor = controller.currentPicker == .start ? .red : .black
			controller.endValueLabel.textColor = .black
		} else if indexPath == controller.endIndexPath {
			controller.currentPicker = controller.currentPicker == .end ? .none : .end
			controller.startValueLabel.textColor = .black
			controller.endValueLabel.textColor = controller.currentPicker == .end ? .red : .black
		}
	}
	
	func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
//		guard let controller = controller else { return false }
		
		return indexPath == controller.startIndexPath || indexPath == controller.endIndexPath
	}
}

class AddEventTableViewDataSource: NSObject, UITableViewDataSource {
	var controller: AddEventController
	
	init(for controller: AddEventController) {
		print(#function)
		self.controller = controller
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		print(#function)
		return 2
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//		guard let controller = controller else { return 0 }
		print(#function, section)
		switch section {
		case 0:
			return 1
		case 1:
			return 2 + (controller.currentPicker != .none ? 1 : 0)
		default:
			return 0
		}
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//		guard let controller = controller else { return UITableViewCell() }
		print(#function, indexPath)
		switch (indexPath.section, indexPath.row) {
		case (0, 0):
			let cell = UITableViewCell()
			cell.contentView.addSubview(controller.titleTextField)
			
			NSLayoutConstraint.activate([
				controller.titleTextField.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
				controller.titleTextField.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 20.0),
				controller.titleTextField.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -20.0),
				controller.titleTextField.heightAnchor.constraint(equalToConstant: 30)
				])
			
			return cell
			
		case (controller.startIndexPath.section, controller.startIndexPath.row):
			return AddEventController.UI.startCell(controller.startLabel, controller.startValueLabel)
			
		case (controller.endIndexPath.section, controller.endIndexPath.row):
			return AddEventController.UI.endCell(controller.endLabel, controller.endValueLabel)
			
		case (controller.pickerIndexPath?.section, controller.pickerIndexPath?.row):
			return AddEventController.UI.pickerCell(controller.datePicker)
			
		default:
			return UITableViewCell()
		}
	}
}
