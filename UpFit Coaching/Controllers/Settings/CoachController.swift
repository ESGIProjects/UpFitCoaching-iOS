//
//  CoachController.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 14/07/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit
import MessageUI
import MapKit

class CoachController: UIViewController {
	
	var nameLabel: UILabel!
	var mailLabel: UILabel!
	var phoneLabel: UILabel!
	
	var addressLabel: UILabel!
	var callButton: UIButton!
	var mailButton: UIButton!
	
	let coach = Database().getCurrentUser()?.coach
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = "coachController_title".localized
		view.backgroundColor = .background
		setupLayout()
		
		if #available(iOS 11.0, *) {
			navigationItem.largeTitleDisplayMode = .never
		}
		
		if let coach = coach {
			nameLabel.text = coach.firstName.appending(" ").appending(coach.lastName)
			mailLabel.text = coach.mail
			phoneLabel.text = coach.phoneNumber
			
			guard let address = coach.address else { return }
			let text = address.appending("\n").appending(coach.city)
			
			addressLabel.attributedText = NSAttributedString(string: text, attributes: [
				.underlineStyle: NSUnderlineStyle.styleSingle.rawValue
			])
		} else {
			navigationController?.popViewController(animated: true)
		}
	}
	
	fileprivate func getConstraints() -> [NSLayoutConstraint] {
		let anchors = getAnchors()
		
		return [
			nameLabel.topAnchor.constraint(equalTo: anchors.top, constant: 15.0),
			nameLabel.leadingAnchor.constraint(equalTo: anchors.leading, constant: 15.0),
			nameLabel.trailingAnchor.constraint(equalTo: anchors.trailing, constant: -15.0),
			
			mailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 15.0),
			mailLabel.leadingAnchor.constraint(equalTo: anchors.leading, constant: 15.0),
			mailLabel.trailingAnchor.constraint(equalTo: anchors.trailing, constant: -15.0),
			
			phoneLabel.topAnchor.constraint(equalTo: mailLabel.bottomAnchor, constant: 15.0),
			phoneLabel.leadingAnchor.constraint(equalTo: anchors.leading, constant: 15.0),
			phoneLabel.trailingAnchor.constraint(equalTo: anchors.trailing, constant: -15.0),
			
			addressLabel.topAnchor.constraint(equalTo: phoneLabel.bottomAnchor, constant: 15.0),
			addressLabel.leadingAnchor.constraint(equalTo: anchors.leading, constant: 15.0),
			addressLabel.trailingAnchor.constraint(equalTo: anchors.trailing, constant: -15.0),
			
			callButton.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 15.0),
			callButton.leadingAnchor.constraint(equalTo: anchors.leading, constant: 15.0),
			
			mailButton.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 15.0),
			mailButton.leadingAnchor.constraint(equalTo: callButton.trailingAnchor, constant: 15.0),
			mailButton.trailingAnchor.constraint(equalTo: anchors.trailing, constant: -15.0),
			mailButton.widthAnchor.constraint(equalTo: callButton.widthAnchor)
		]
	}
	
	fileprivate func setUIComponents() {
		nameLabel = UI.titleLabel
		nameLabel.numberOfLines = 2
		
		mailLabel = UI.headlineLabel
		mailLabel.numberOfLines = 2
		
		phoneLabel = UI.headlineLabel
		phoneLabel.numberOfLines = 2
		
		addressLabel = UI.headlineLabel
		addressLabel.numberOfLines = 2
		addressLabel.isUserInteractionEnabled = true
		addressLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(address)))
		
		callButton = UI.roundButton
		callButton.titleText = "callButton".localized
		callButton.addTarget(self, action: #selector(call), for: .touchUpInside)
		
		mailButton = UI.roundButton
		mailButton.titleText = "sendMailButton".localized
		mailButton.addTarget(self, action: #selector(mail), for: .touchUpInside)
	}
	
	func setupLayout() {
		setUIComponents()
		
		view.addSubview(nameLabel)
		view.addSubview(mailLabel)
		view.addSubview(phoneLabel)
		view.addSubview(addressLabel)
		view.addSubview(callButton)
		view.addSubview(mailButton)
		
		NSLayoutConstraint.activate(getConstraints())
	}
	
	@objc func call() {
		guard let coach = coach else { return }
		guard let callURL = URL(string: "tel://\(coach.phoneNumber)"),
			UIApplication.shared.canOpenURL(callURL) else { return }
		
		UIApplication.shared.open(callURL, options: [:])
	}
	
	@objc func mail() {
		if MFMailComposeViewController.canSendMail() {
			guard let coach = coach else { return }
			
			let mailController = MFMailComposeViewController()
			mailController.mailComposeDelegate = self
			mailController.setToRecipients([coach.mail])
			
			present(mailController, animated: true)
		} else {
			presentAlert(title: "mailAppMissing_title".localized, message: "mailAppMissing_message".localized)
		}
	}
	
	@objc func address() {
		guard let address = coach?.address else { return }
		
		CLGeocoder().geocodeAddressString(address) { [weak self] placemarks, error in
			if error != nil {
				DispatchQueue.main.async {
					self?.presentAlert(title: "error".localized, message: "geocoderError".localized)
				}
			} else {
				guard let topResult = placemarks?.first else { return }
				
				let placemark = MKPlacemark(placemark: topResult)
				let item = MKMapItem(placemark: placemark)
				
				item.openInMaps()				
			}
		}
	}
}

// MARK: - MFMailComposeViewControllerDelegate
extension CoachController: MFMailComposeViewControllerDelegate {
	func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
		controller.dismiss(animated: true)
	}
}
