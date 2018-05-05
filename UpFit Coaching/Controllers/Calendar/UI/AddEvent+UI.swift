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
		class func tableView(delegate: UITableViewDelegate? = nil, dataSource: UITableViewDataSource? = nil) -> UITableView {
			let view = UITableView(frame: .zero, style: .grouped)
			view.translatesAutoresizingMaskIntoConstraints = false
			
			view.delegate = delegate
			view.dataSource = dataSource

			return view
		}
		
		class func titleTextField() -> UITextField {
			let view = UITextField(frame: .zero)
			view.translatesAutoresizingMaskIntoConstraints = false
						
			view.placeholder = "Title"
			view.keyboardType = .asciiCapable
			view.clearButtonMode = .whileEditing
			view.returnKeyType = .next
			
			return view
		}
		
		class func startLabel() -> UILabel {
			let view = UILabel()
			view.translatesAutoresizingMaskIntoConstraints = false
			
			view.text = "Start"
			
			return view
		}
		
		class func startValueLabel() -> UILabel {
			let view = UILabel()
			view.translatesAutoresizingMaskIntoConstraints = false
			
			view.text = "5 mai 2018\t15:00"
			
			return view
		}
		
		class func endLabel() -> UILabel {
			let view = UILabel()
			view.translatesAutoresizingMaskIntoConstraints = false
			
			view.text = "End"
			
			return view
		}
		
		class func endValueLabel() -> UILabel {
			let view = UILabel()
			view.translatesAutoresizingMaskIntoConstraints = false
			
			view.text = "16:00"
			
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
	
	func getConstraints(for controller: AddEventController) -> [NSLayoutConstraint] {
		let anchors = controller.getAnchors()
		
		return [
			tableView.topAnchor.constraint(equalTo: anchors.top),
			tableView.bottomAnchor.constraint(equalTo: anchors.bottom),
			tableView.leadingAnchor.constraint(equalTo: anchors.leading),
			tableView.trailingAnchor.constraint(equalTo: anchors.trailing)
		]
	}
}
