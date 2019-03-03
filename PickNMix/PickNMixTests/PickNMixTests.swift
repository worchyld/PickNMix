//
//  PickNMixTests.swift
//  PickNMixTests
//
//  Created by Amarjit on 01/03/2019.
//  Copyright © 2019 Amarjit. All rights reserved.
//

import XCTest
@testable import PickNMix
@testable import RealmSwift

class PickNMixTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // Use an in-memory Realm identified by the name of the current test.
        // This ensures that each test can't accidentally access or modify the data
        // from other tests or the application itself, and because they're in-memory,
        // there's nothing that needs to be cleaned up.
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }




}
