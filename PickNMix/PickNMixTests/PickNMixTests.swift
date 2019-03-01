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
        //func beers(page: Int, pageSize: Int, completion: @escaping (Result<[Beer]>) -> ()) {

        let service = PickNMixAPI.ideas()
        let httpClient: HTTPClientType

        httpClient.getResources(at: service, completion: @escaping (Result<[Idea]>) -> (
            print
            ))

    }
}
