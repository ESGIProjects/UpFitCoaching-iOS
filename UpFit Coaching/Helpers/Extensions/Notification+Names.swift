//
//  Notification+Names.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 23/04/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
// Version 1.0

import Foundation

extension Notification.Name {
	static let messagesDownloaded = Notification.Name("messagesDownloaded")
	static let eventsDownloaded = Notification.Name("eventsDownloaded")
	static let threadsDownloaded = Notification.Name("threadsDownloaded")
	static let postsDownloaded = Notification.Name("postsDownloaded")
	static let followUpDownloaded = Notification.Name("followUpDownloaded")
}
