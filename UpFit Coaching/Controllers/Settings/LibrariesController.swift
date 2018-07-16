//
//  LibrariesController.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 24/06/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
// Version 1.0

import UIKit
import WebKit
import SafariServices

class LibrariesController: UIViewController {
	
	var webView: WKWebView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = "librariesController_title".localized
		view.backgroundColor = .background
		setupLayout()
		
		if #available(iOS 11.0, *) {
			navigationItem.largeTitleDisplayMode = .never
		}
		
		guard let path = Bundle.main.path(forResource: "libraries", ofType: "html") else { return }
		
		let url = URL(fileURLWithPath: path)
		webView.loadFileURL(url, allowingReadAccessTo: url)
		webView.navigationDelegate = self
	}
}

extension LibrariesController {
	fileprivate func getConstraints() -> [NSLayoutConstraint] {
		let anchors = getAnchors()
		
		return [
			webView.topAnchor.constraint(equalTo: anchors.top),
			webView.leadingAnchor.constraint(equalTo: anchors.leading),
			webView.trailingAnchor.constraint(equalTo: anchors.trailing),
			webView.bottomAnchor.constraint(equalTo: anchors.bottom)
		]
	}
	
	func setupLayout() {
		webView = WKWebView(frame: .zero)
		webView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(webView)
		
		NSLayoutConstraint.activate(getConstraints())
	}
}

extension LibrariesController: WKNavigationDelegate {
	func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
		
		guard let url = navigationAction.request.url,
			navigationAction.navigationType == .linkActivated else { decisionHandler(.allow); return }
		
		let safariViewController = SFSafariViewController(url: url)
		safariViewController.preferredBarTintColor = .red
		safariViewController.preferredControlTintColor = .green
		
		present(safariViewController, animated: true)
		decisionHandler(.cancel)
	}
}
