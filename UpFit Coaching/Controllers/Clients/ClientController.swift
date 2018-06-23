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
	var showsFullLayout = false
	
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
	
	@objc func newAppraisal() {
		present(UINavigationController(rootViewController: EditAppraisalController()), animated: true)
	}
	
	@objc func showAppraisal() {
		
	}
	
	@objc func updateMeasurements() {
		present(UINavigationController(rootViewController: AddMeasurementsController()), animated: true)
	}
	
	@objc func newTest() {
		present(UINavigationController(rootViewController: NewTestController()), animated: true)
	}
	
	// MARK: - Helpers
	
	func downloadData() {
		guard let client = client else { return }
		HUD.show(.progress)
		
		let dispatchGroup = DispatchGroup()
		
		// Dowload appraisal
		dispatchGroup.enter()
		downloadAppraisal(for: client, in: dispatchGroup)
		
		// Download measurements
		dispatchGroup.enter()
		downloadMeasurements(for: client, in: dispatchGroup)
		
		// Download tests
		dispatchGroup.enter()
		downloadTests(for: client, in: dispatchGroup)
		
		// Refresh UI when done
		dispatchGroup.notify(queue: .main) { [weak self] in
			DispatchQueue.main.async {
				HUD.hide()
				self?.refreshLayout()
			}
		}
	}
	
	private func downloadAppraisal(for client: User, in dispatch: DispatchGroup? = nil) {
		Network.getLastAppraisal(for: client) { data, response, _ in
			guard let data = data else { return }
			
			if Network.isSuccess(response: response, successCode: 200) {
				// Setting up JSON Decoder
				let decoder = JSONDecoder.withDate
				
				// Decode appraisal
				guard let appraisal = try? decoder.decode(Appraisal.self, from: data) else { return }
				
				// Save appraisal
				Database().createOrUpdate(model: appraisal, with: AppraisalObject.init)
			}
			dispatch?.leave()
		}
	}
	
	private func downloadMeasurements(for client: User, in dispatch: DispatchGroup? = nil) {
		Network.getMeasurements(for: client) { data, response, _ in
			guard let data = data else { return }
			
			if Network.isSuccess(response: response, successCode: 200) {
				// Setting up JSON Decoder
				let decoder = JSONDecoder.withDate
				
				// Decode measurements
				guard let measurements = try? decoder.decode([Measurements].self, from: data) else { return }
				
				// Save appraisal
				Database().createOrUpdate(models: measurements, with: MeasurementsObject.init)
			}
			dispatch?.leave()
		}
	}
	
	private func downloadTests(for client: User, in dispatch: DispatchGroup? = nil) {
		Network.getTests(for: client) { data, response, _ in
			guard let data = data else { return }
			
			if Network.isSuccess(response: response, successCode: 200) {
				// Setting up JSON Decoder
				let decoder = JSONDecoder.withDate
				
				// Decode tests
				guard let tests = try? decoder.decode([Test].self, from: data) else { return }
				
				print(tests)
				
				// Save appraisal
				Database().createOrUpdate(models: tests, with: TestObject.init)
			}
			dispatch?.leave()
		}
	}
}

// MARK: - MFMailComposeViewControllerDelegate
extension ClientController: MFMailComposeViewControllerDelegate {
	func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
		controller.dismiss(animated: true)
	}
}
