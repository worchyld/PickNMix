//
//  Business.swift
//  PickNMix
//
//  Created by Amarjit on 01/03/2019.
//  Copyright © 2019 Amarjit. All rights reserved.
//

import Foundation

// BusinessModels
struct BusinessModels : Decodable {
    let name : [String]

    //Custom Keys
    enum CodingKeys: String, CodingKey {
        case name = "businessModels" //Custom keys
    }
}
