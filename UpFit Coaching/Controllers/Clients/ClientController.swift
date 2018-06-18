//
//  ClientController.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 16/06/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit
import MessageUI

class ClientController: UIViewController {
	
	var nameLabel: UILabel!
	var birthDateLabel: UILabel!
	var cityLabel: UILabel!
	var callButton: UIButton!
	var mailButton: UIButton!
	var followUpButton: UIButton!
	var appraisalButton: UIButton!
	var measurementsButton: UIButton!
	var testButton: UIButton!
	
	var appraisalTopConstraint: NSLayoutConstraint!
	
	var client: User?
	
	// MARK: - UIViewController
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = "clientController_title".localized
		view.backgroundColor = .background
		setupLayout()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		guard let client = client,
			let birthDate = client.birthDate else { return }
		
		let dateComponents = Calendar.current.dateComponents([.year], from: birthDate, to: Date())
		guard let age = dateComponents.year else { return }
		
		nameLabel.text = "clientName_titleLabel".localized(with: client.firstName, client.lastName, "\(age)")
		
		let dateFormatter = DateFormatter()
		dateFormatter.dateStyle = .medium
		dateFormatter.timeStyle = .none
		
		birthDateLabel.text = "sexAndBirthDate_label".localized(with: "sex_\(0)".localized, dateFormatter.string(from: birthDate))
		cityLabel.text = "city_label".localized(with: client.city)
	}
	
	// MARK: - Actions
	
	@objc func call() {
		guard let client = client else { return }
		guard let callURL = URL(string: "tel://\(client.phoneNumber)"),
			UIApplication.shared.canOpenURL(callURL) else { return }

		UIApplication.shared.open(callURL, options: [:])
	}
	
	@objc func mail() {
		if MFMailComposeViewController.canSendMail() {
			guard let client = client else { return }
			
			let mailController = MFMailComposeViewController()
			mailController.mailComposeDelegate = self
			mailController.setToRecipients([client.mail])
			
			present(mailController, animated: true)
		} else {
			presentAlert(title: "mailAppMissing_title", message: "mailAppMissing_message")
		}
	}
}

// MARK: - MFMailComposeViewControllerDelegate
extension ClientController: MFMailComposeViewControllerDelegate {
	func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
		controller.dismiss(animated: true)
	}
}
