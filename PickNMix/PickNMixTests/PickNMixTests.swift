//
//  PickNMixTests.swift
//  PickNMixTests
//
//  Created by Amarjit on 01/03/2019.
//  Copyright © 2019 Amarjit. All rights reserved.
//

import XCTest
@testable import PickNMix

class PickNMixTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testHTTPService() {

        guard let url = Constants.API.url else {
            XCTFail("No URL defined")
            return
        }

        PickMixAPI.executeRequestURL(url) { (success, error, data) in
            if (error != nil) {
                XCTFail("Error -- \(error?.localizedDescription as Any)")
            }
        }

    }


}
