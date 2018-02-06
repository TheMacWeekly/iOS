//
//  The_Mac_WeeklyTests.swift
//  The Mac WeeklyTests
//
//  Created by Library Checkout User on 2/3/18.
//  Copyright © 2018 The Mac Weekly. All rights reserved.
//

import XCTest
@testable import The_Mac_Weekly

class The_Mac_WeeklyTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        let expectation = self.expectation(description: "Request should complete")

        let test = The_Mac_Weekly.getPost(postID: 73359) { post in
            print("WOW!", post)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5000, handler: nil)
        
//        The_Mac_Weekly.getPost(1)
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
