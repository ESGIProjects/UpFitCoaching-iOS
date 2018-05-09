//
//  AddEvent+UI.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 04/05/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit

extension AddEventController {
	class UI {
		class func tableView() -> UITableView {
			let view = UITableView(frame: .zero, style: .grouped)
			view.translatesAutoresizingMaskIntoConstraints = false

			return view
		}
		
		class func titleTextField() -> UITextField {
			let view = UITextField(frame: .zero)
			view.translatesAutoresizingMaskIntoConstraints = false
			
			view.placeholder = "eventTitle_placeholder".localized
			view.keyboardType = .asciiCapable
			view.clearButtonMode = .whileEditing
			view.returnKeyType = .next
			
			return view
		}
		
		class func startLabel() -> UILabel {
			let view = UILabel()
			view.translatesAutoresizingMaskIntoConstraints = false
			
			view.text = "eventStart_label".localized
			
			return view
		}
		
		class func startValueLabel() -> UILabel {
			let view = UILabel()
			view.translatesAutoresizingMaskIntoConstraints = false
			
			return view
		}
		
		class func endLabel() -> UILabel {
			let view = UILabel()
			view.translatesAutoresizingMaskIntoConstraints = false
			
			view.text = "eventEnd_label".localized
			
			return view
		}
		
		class func endValueLabel() -> UILabel {
			let view = UILabel()
			view.translatesAutoresizingMaskIntoConstraints = false
			
			return view
		}
		
		class func datePicker() -> UIDatePicker {
			let view = UIDatePicker(frame: .zero)
			view.translatesAutoresizingMaskIntoConstraints = false
			
			return view
		}
		
		class func startCell(_ label: UILabel, _ valueLabel: UILabel) -> UITableViewCell {
			let cell = UITableViewCell()
			cell.contentView.addSubview(label)
			cell.contentView.addSubview(valueLabel)
			
			NSLayoutConstraint.activate([
				label.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
				valueLabel.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
				
				label.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 20.0),
				label.trailingAnchor.constraint(equalTo: valueLabel.leadingAnchor),
				valueLabel.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -20.0),
				
				label.heightAnchor.constraint(equalToConstant: 44),
				valueLabel.heightAnchor.constraint(equalToConstant: 44)
				])
			
			return cell
		}
		
		class func pickerCell(_ picker: UIDatePicker) -> UITableViewCell {
			let cell = UITableViewCell()
			cell.contentView.addSubview(picker)
			
			NSLayoutConstraint.activate([
				picker.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
				picker.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor),
				picker.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor),
				picker.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor)
				])
			
			return cell
		}
		
		class func endCell(_ label: UILabel, _ valueLabel: UILabel) -> UITableViewCell {
			let cell = UITableViewCell()
			cell.contentView.addSubview(label)
			cell.contentView.addSubview(valueLabel)
			
			NSLayoutConstraint.activate([
				label.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
				valueLabel.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
				
				label.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 20.0),
				label.trailingAnchor.constraint(equalTo: valueLabel.leadingAnchor),
				valueLabel.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -20.0),
				
				label.heightAnchor.constraint(equalToConstant: 44),
				valueLabel.heightAnchor.constraint(equalToConstant: 44)
				])
			
			return cell
		}
	}
	
	func getConstraints() -> [NSLayoutConstraint] {
		let anchors = getAnchors()
		
		return [
			tableView.topAnchor.constraint(equalTo: anchors.top),
			tableView.bottomAnchor.constraint(equalTo: anchors.bottom),
			tableView.leadingAnchor.constraint(equalTo: anchors.leading),
			tableView.trailingAnchor.constraint(equalTo: anchors.trailing)
		]
	}
	
	func setUIComponents() {
		tableView = UI.tableView()
		tableView.delegate = self
		tableView.dataSource = self
		
		titleTextField = UI.titleTextField()
		startLabel = UI.startLabel()
		startValueLabel = UI.startValueLabel()
		endLabel = UI.endLabel()
		endValueLabel = UI.endValueLabel()
		datePicker = UI.datePicker()
	}
	
	func setupLayout() {
		setUIComponents()
		
		view.addSubview(tableView)
		NSLayoutConstraint.activate(getConstraints())
	}
}
