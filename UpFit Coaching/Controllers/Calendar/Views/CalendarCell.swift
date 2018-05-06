//
//  CustomCell.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 22/04/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CalendarCell: JTAppleCell {
	lazy var selectedBackground: UIView = {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.backgroundColor = #colorLiteral(red: 0.3411764706, green: 0.4941176471, blue: 0.8745098039, alpha: 1)
		view.layer.cornerRadius = 20.0
		view.isHidden = true
		return view
	}()
	
	lazy var dateLabel: UILabel = {
		let label = UILabel(frame: .zero)
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		setupLayout()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setupLayout() {
		contentView.addSubview(selectedBackground)
		contentView.addSubview(dateLabel)
		
		NSLayoutConstraint.activate([
			selectedBackground.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
			selectedBackground.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
			selectedBackground.heightAnchor.constraint(equalToConstant: 40.0),
			selectedBackground.widthAnchor.constraint(equalToConstant: 40.0),
			
			dateLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
			dateLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
			])
	}
}
