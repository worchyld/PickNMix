//
//  DBManager.swift
//  PickNMix
//
//  Created by Amarjit on 03/03/2019.
//  Copyright © 2019 Amarjit. All rights reserved.
//

import Foundation
import RealmSwift

class DBManager {
    static func save (object: Object, completion: @escaping () -> Void) {
        DispatchQueue(label: "background").async {
            autoreleasepool {
                let realm = try! Realm()
                realm.beginWrite()
                realm.add(object)
                try! realm.commitWrite()
                completion()
            }
        }
    }

    static func save (objects: [Object], completion: @escaping () -> Void) {
        let realm = try! Realm()
        realm.beginWrite()
        realm.add(objects)
        try! realm.commitWrite()
        completion()
    }

    static func delete (object: Object, completion: @escaping () -> Void) {
        DispatchQueue(label: "background").async {
            autoreleasepool {
                let realm = try! Realm()
                realm.beginWrite()
                realm.delete(object)
                try! realm.commitWrite()
                completion()
            }
        }
    }

    static func clearAll() {
        DispatchQueue(label: "background").async {
            autoreleasepool {
                let realm = try! Realm()
                realm.beginWrite()
                realm.deleteAll()
                try! realm.commitWrite()
            }
        }
    }

    static func clearAll(completion: @escaping () -> Void) {
        DispatchQueue(label: "background").async {
            autoreleasepool {
                let realm = try! Realm()
                realm.beginWrite()
                realm.deleteAll()
                try! realm.commitWrite()
                completion()
            }
        }

    }

}

extension DBManager {

    public static func getBusinessEntities() -> Results<BusinessEntity>? {
        let realm = try! Realm()
        let businessModels = realm.objects(BusinessEntity.self)
        return businessModels
    }

    public static func getIndustryEntities() -> Results<IndustryEntity>? {
        let realm = try! Realm()
        let industries = realm.objects(IndustryEntity.self)
        return industries
    }

    public static func getTriggerEntities() -> Results<TriggerEntity>? {
        let realm = try! Realm()
        let triggers = realm.objects(TriggerEntity.self)
        return triggers
    }

}
