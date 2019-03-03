//
//  BusinessEntity.swift
//  PickNMix
//
//  Created by Amarjit on 02/03/2019.
//  Copyright © 2019 Amarjit. All rights reserved.
//

import Foundation
import RealmSwift

// DB entity
class BusinessEntity: Object {
    @objc dynamic var name : String = ""
}
