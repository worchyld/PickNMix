//
//  Industry.swift
//  PickNMix
//
//  Created by Amarjit on 01/03/2019.
//  Copyright © 2019 Amarjit. All rights reserved.
//

import Foundation
import ObjectMapper

// Industry model
struct Industry {
    let name: String
}

/*
class Industry : NSObject{
    public private (set) var name : String!

    required init?(map: Map) {
        super.init()
    }

    // Mappable
    func mapping(map: Map) {
        name    <- map["industries"]
    }
}
*/
