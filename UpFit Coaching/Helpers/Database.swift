//
//  Database.swift
//  UpFit Coaching
//
//  Created by Jason Pierna on 15/04/2018.
//  Copyright © 2018 Jason Pierna. All rights reserved.
//

import Foundation
import RealmSwift

struct FetchRequest<Model, RealmObject: Object> {
	let predicate: NSPredicate?
	let sortDescriptors: [SortDescriptor]
	let transformer: (Results<RealmObject>) -> Model
}

final class Database {
	private let realm: Realm
	
	init() {
		do {
			realm = try Realm()
		} catch {
			fatalError(error.localizedDescription)
		}
	}
	
	func createOrUpdate<Model, RealmObject: Object>(model: Model, with reverseTransformer: (Model) -> RealmObject) {
		let object = reverseTransformer(model)
		
		try? realm.write {
			realm.add(object, update: true)
		}
	}
	
	func createOrUpdate<Model, RealmObject: Object>(models: [Model], with reverseTransformer: (Model) -> RealmObject) {
		let objects = models.map { reverseTransformer($0) }
		
		try? realm.write {
			realm.add(objects, update: true)
		}
	}
	
	func fetch<Model, RealmObject: Object>(with predicate: NSPredicate?, sortDescriptors: [SortDescriptor], transformer: (Results<RealmObject>) -> Model) -> Model {
		var results = realm.objects(RealmObject.self)
		
		if let predicate = predicate {
			results = results.filter(predicate)
		}
		
		if sortDescriptors.count > 0 {
			results = results.sorted(by: sortDescriptors)
		}
		
		return transformer(results)
	}
	
	func fetch<Model, RealmObject: Object>(using request: FetchRequest<Model, RealmObject>) -> Model {
		return fetch(with: request.predicate, sortDescriptors: request.sortDescriptors, transformer: request.transformer)
	}
	
	func next<RealmObject: Object>(type: RealmObject.Type, of property: String) -> Int {		
		guard let max = realm.objects(type).max(ofProperty: property) as Int? else { return 1 }
		return max
	}
	
	func reverseNext<RealmObject: Object>(type: RealmObject.Type, of property: String) -> Int {
		guard let min = realm.objects(type).min(ofProperty: property) as Int? else { return -1 }
		return min > 0 ? -1 : min
	}
	
	func delete<RealmObject: Object>(type: RealmObject.Type, with primaryKey: Int) {
		let object = realm.object(ofType: type, forPrimaryKey: primaryKey)
		
		if let object = object {
			try? realm.write {
				realm.delete(object)
			}
		}
	}
	
	func deleteAll() {
		try? realm.write {
			realm.deleteAll()
		}		
	}
	
	func deleteAll<RealmObject: Object>(of type: RealmObject.Type) {
		try? realm.write {
			realm.delete(realm.objects(type))
		}
	}
}
