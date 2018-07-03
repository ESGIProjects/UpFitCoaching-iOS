//
//  ClientController.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 16/06/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import UIKit
import MessageUI
import PKHUD

class ClientController: UIViewController {
	
	var scrollView: UIScrollView!
	var contentView: UIView!
	var nameLabel: UILabel!
	var birthDateLabel: UILabel!
	var cityLabel: UILabel!
	var callButton: UIButton!
	var mailButton: UIButton!
	var appraisalTitle: UILabel!
	var appraisalLabel: UILabel!
	var followUpButton: UIButton!
	var appraisalButton: UIButton!
	var testTitle: UILabel!
	var testLabel: UILabel!
	var testButton: UIButton!
	var prescriptionButton: UIButton!
	
	var appraisalTopConstraint: NSLayoutConstraint!
	var testTopConstraint: NSLayoutConstraint!
	var showsFullLayout = false
	var showsTestLayout = false
	
	var client: User?
	
	// MARK: - UIViewController
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = "clientController_title".localized
		view.backgroundColor = .background
		setupLayout()
		
		// Download appraisal
		downloadData()
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
		
		birthDateLabel.text = "sexAndBirthDate_label".localized(with: "sex_\(client.sex)".localized, dateFormatter.string(from: birthDate))
		cityLabel.text = "city_label".localized(with: client.city)
		
		let database = Database()

		if let lastAppraisal = database.getLastAppraisal(for: client) {
			let appraisalString = "appraisal_goalLabel".localized(with: lastAppraisal.goal)
				.appending("\n")
				.appending("appraisal_sessionsNumberLabel".localized(with: lastAppraisal.sessionsByWeek))
			
			appraisalLabel.text = appraisalString
		}
		
		if let lastTest = database.getLastTest(for: client) {
			let numberFormatter = NumberFormatter()
			numberFormatter.alwaysShowsDecimalSeparator = false
			numberFormatter.maximumFractionDigits = 1
			
			if let warmUp = numberFormatter.string(from: NSNumber(value: lastTest.warmUp)),
				let frequency = numberFormatter.string(from: NSNumber(value: lastTest.frequency)) {
				testLabel.text = "test_warmUpSpeedLabel".localized(with: warmUp)
				testLabel.text?.append("\n")
				testLabel.text?.append("test_frequencyLabel".localized(with: frequency))

			} else {
				testLabel.text = ""
			}
		}
		
		refreshLayout()
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
			presentAlert(title: "mailAppMissing_title".localized, message: "mailAppMissing_message".localized)
		}
	}
	
	@objc func appraisal() {
		guard let client = client else { return }
	
		let editAppraisalController = EditAppraisalController()
		editAppraisalController.client = client
		editAppraisalController.appraisal = Database().getLastAppraisal(for: client)
		
		present(UINavigationController(rootViewController: editAppraisalController), animated: true)
	}
	
	@objc func followUp() {
		guard let client = client else { return }
		
		let followUpController = FollowUpController()
		followUpController.user = client
		
		navigationController?.pushViewController(followUpController, animated: true)
	}
	
	@objc func test() {
		guard let client = client else { return }
		
		let newTestController = NewTestController()
		newTestController.client = client
		newTestController.oldTest = Database().getLastTest(for: client)
		
		present(UINavigationController(rootViewController: newTestController), animated: true)
	}
	
	// MARK: - Helpers
	
	func downloadData() {
		guard let client = client else { return }
		HUD.show(.progress)
		
		let dispatchGroup = DispatchGroup()
		
		// Download appraisal, measurements & tests
		Downloader.appraisal(for: client, in: dispatchGroup)
		Downloader.measurements(for: client, in: dispatchGroup)
		Downloader.tests(for: client, in: dispatchGroup)
		
		// Refresh UI when done
		dispatchGroup.notify(queue: .main) { [weak self] in
			DispatchQueue.main.async {
				HUD.hide()
				self?.refreshLayout()
			}
		}
	}
}

// MARK: - MFMailComposeViewControllerDelegate
extension ClientController: MFMailComposeViewControllerDelegate {
	func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
		controller.dismiss(animated: true)
	}
}
