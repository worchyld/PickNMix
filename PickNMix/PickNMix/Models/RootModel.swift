//
//  RootModel.swift
//  PickNMix
//
//  Created by Amarjit on 03/03/2019.
//  Copyright © 2019 Amarjit. All rights reserved.
//

import Foundation

struct Root: Decodable {
    let industries: [String]
    let triggers: [String]
    let businessModels: [[String]]

    var businessModelsFlattened: [String] {
        return businessModels.flatMap({$0})
    }
}
