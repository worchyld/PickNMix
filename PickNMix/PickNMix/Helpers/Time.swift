//
//  Time.swift
//  PickNMix
//
//  Created by Amarjit on 02/03/2019.
//  Copyright © 2019 Amarjit. All rights reserved.
//

import Foundation

func waitFor(duration: TimeInterval, callback: @escaping (Bool) -> ()) {
    let when = DispatchTime.now() + duration
    DispatchQueue.main.asyncAfter(deadline: when) {
        callback(true)
    }
}
