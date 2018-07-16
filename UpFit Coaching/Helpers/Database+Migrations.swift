//
//  Database+Migrations.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 19/06/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
// Version 1.0

import Foundation
import RealmSwift

extension Database {
	static let currentSchemaVersion: UInt64 = 1
	
	class func migrations() {
		let configuration = Realm.Configuration(schemaVersion: currentSchemaVersion, migrationBlock: { migration, oldSchemaVersion in
			if oldSchemaVersion < 1 {
				migrateFrom0To1(with: migration)
			}
		})
		
		Realm.Configuration.defaultConfiguration = configuration
	}
	
	class func migrateFrom0To1(with migration: Migration) {
		// Add UserObject.sex property
		migration.enumerateObjects(ofType: UserObject.className()) { _, newUser in
			newUser?["sex"] = 1
		}
	}
}
