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
	
	var selectedBackground: UIView!
	var appraisalIndicatorView: UIView!
	var sessionIndicatorView: UIView!
	var dateLabel: UILabel!
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		setupLayout()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setUIComponents() {
		selectedBackground = UIView()
		selectedBackground.translatesAutoresizingMaskIntoConstraints = false
		selectedBackground.backgroundColor = #colorLiteral(red: 0.3411764706, green: 0.4941176471, blue: 0.8745098039, alpha: 1)
		selectedBackground.layer.cornerRadius = 15.0
		selectedBackground.isHidden = true
		
		appraisalIndicatorView = UIView()
		appraisalIndicatorView.translatesAutoresizingMaskIntoConstraints = false
		appraisalIndicatorView.backgroundColor = #colorLiteral(red: 0.3411764706, green: 0.4941176471, blue: 0.8745098039, alpha: 1)
		appraisalIndicatorView.layer.cornerRadius = 2.0
		
		sessionIndicatorView = UIView()
		sessionIndicatorView.translatesAutoresizingMaskIntoConstraints = false
		sessionIndicatorView.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
		sessionIndicatorView.layer.cornerRadius = 2.0
		
		dateLabel = UILabel(frame: .zero)
		dateLabel.translatesAutoresizingMaskIntoConstraints = false
	}
	
	private func setupLayout() {
		setUIComponents()
		
		contentView.addSubview(selectedBackground)
		contentView.addSubview(dateLabel)
		NSLayoutConstraint.activate([
			selectedBackground.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
			selectedBackground.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
			selectedBackground.heightAnchor.constraint(equalToConstant: 30.0),
			selectedBackground.widthAnchor.constraint(equalToConstant: 30.0),
			
			dateLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
			dateLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
			])
	}
	
	func setIndicators(appraisal: Bool, session: Bool) {
		appraisalIndicatorView.removeFromSuperview()
		sessionIndicatorView.removeFromSuperview()
		
		if appraisal && session {
			contentView.addSubview(appraisalIndicatorView)
			contentView.addSubview(sessionIndicatorView)
			
			NSLayoutConstraint.activate([
				appraisalIndicatorView.topAnchor.constraint(equalTo: selectedBackground.bottomAnchor, constant: 2.0),
				appraisalIndicatorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -4.0),
				appraisalIndicatorView.heightAnchor.constraint(equalToConstant: 4.0),
				appraisalIndicatorView.widthAnchor.constraint(equalToConstant: 4.0),
				
				sessionIndicatorView.topAnchor.constraint(equalTo: selectedBackground.bottomAnchor, constant: 2.0),
				sessionIndicatorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 4.0),
				sessionIndicatorView.heightAnchor.constraint(equalToConstant: 4.0),
				sessionIndicatorView.widthAnchor.constraint(equalToConstant: 4.0)
				])
		} else if appraisal {
			contentView.addSubview(appraisalIndicatorView)
			
			NSLayoutConstraint.activate([
				appraisalIndicatorView.topAnchor.constraint(equalTo: selectedBackground.bottomAnchor, constant: 3.0),
				appraisalIndicatorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
				appraisalIndicatorView.heightAnchor.constraint(equalToConstant: 4.0),
				appraisalIndicatorView.widthAnchor.constraint(equalToConstant: 4.0)
				])
		} else if session {
			contentView.addSubview(sessionIndicatorView)

			NSLayoutConstraint.activate([
				sessionIndicatorView.topAnchor.constraint(equalTo: selectedBackground.bottomAnchor, constant: 3.0),
				sessionIndicatorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
				sessionIndicatorView.heightAnchor.constraint(equalToConstant: 4.0),
				sessionIndicatorView.widthAnchor.constraint(equalToConstant: 4.0)
				])
		}
	}
}
