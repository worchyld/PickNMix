//
//  DBManager.swift
//  PickNMix
//
//  Created by Amarjit on 03/03/2019.
//  Copyright © 2019 Amarjit. All rights reserved.
//

import Foundation
import RealmSwift

class DatabaseManager {

    public static func getBusinessEntities() -> Results<IndustryEntity>? {
        let realm = try! Realm()
        let industries = realm.objects(IndustryEntity.self)
        return industries
    }
}
