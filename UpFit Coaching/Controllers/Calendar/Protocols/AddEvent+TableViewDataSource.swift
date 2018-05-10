//
//  AddEvent+TableViewDataSource.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 10/05/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit

extension AddEventController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if indexPath == pickerIndexPath {
			return UITableViewAutomaticDimension
		}
		
		return 44.0
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 2
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch section {
		case 0:
			return 1
		case 1:
			return 2 + (currentPicker != .none ? 1 : 0)
		default:
			return 0
		}
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		switch (indexPath.section, indexPath.row) {
		case (0, 0):
			let cell = UITableViewCell()
			cell.contentView.addSubview(titleTextField)
			
			NSLayoutConstraint.activate([
				titleTextField.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
				titleTextField.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 20.0),
				titleTextField.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -20.0),
				titleTextField.heightAnchor.constraint(equalToConstant: 30)
				])
			
			return cell
			
		case (startIndexPath.section, startIndexPath.row):
			return UI.startCell(startLabel, startValueLabel)
			
		case (endIndexPath.section, endIndexPath.row):
			return UI.endCell(endLabel, endValueLabel)
			
		case (pickerIndexPath?.section, pickerIndexPath?.row):
			return UI.pickerCell(datePicker)
			
		default:
			return UITableViewCell()
		}
	}
}
