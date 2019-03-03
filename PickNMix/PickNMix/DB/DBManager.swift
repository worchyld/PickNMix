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

    public static func getBusinessEntities() -> Results<IndustryEntity>? {
        let realm = try! Realm()
        let industries = realm.objects(IndustryEntity.self)
        return industries
    }

    static func save (objects: [Object], completion: @escaping () -> Void) {
        //        DispatchQueue(label: "background").async {
        //            autoreleasepool {
        let realm = try! Realm()
        realm.beginWrite()
        realm.add(objects, update:true)
        try! realm.commitWrite()
        completion()
        //            }
        //        }
    }
}

extension Object {
    static func deleteAll(in realm: Realm) throws {
        let allObjects = realm.objects(self)
        try realm.write {
            realm.delete(allObjects)
        }
    }


}
