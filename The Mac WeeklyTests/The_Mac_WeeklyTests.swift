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
    
//    func testExample() {
//        let expectation = self.expectation(description: "Request should complete")
//
//        // This was causing compiler errors for some reason
//        // Error: [Module "The_Mac_Weekly" has no member named "getPost"]
//        let test = The_Mac_Weekly.getPost(postID: 73359) { post in
//            print("WOW!", post)
//            expectation.fulfill()
//        }
//
//        waitForExpectations(timeout: 5000, handler: nil)
//
////        The_Mac_Weekly.getPost(1)
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//    }
    
    // MARK: Date Formatting Tests
    func testMoreThanThreeDays() {
        let timeInterval: TimeInterval = 300000.0
        XCTAssertNil(TestableUtils.getTimeUnitToUse(timeInterval: timeInterval))
    }
    
    func testUsesDaysUnit() {
        let timeInterval: TimeInterval = 90000.0
        XCTAssertEqual(TestableUtils.getTimeUnitToUse(timeInterval: timeInterval), NSCalendar.Unit.day)
    }
    
    func testUsesHoursUnit() {
        let timeInterval: TimeInterval = 4000.0
        XCTAssertEqual(TestableUtils.getTimeUnitToUse(timeInterval: timeInterval), NSCalendar.Unit.hour)
    }
    
    func testUsesMinutesUnit() {
        let timeInterval: TimeInterval = 120.0
        XCTAssertEqual(TestableUtils.getTimeUnitToUse(timeInterval: timeInterval), NSCalendar.Unit.minute)
    }
    
    func testUsesSecondsUnit() {
        let timeInterval: TimeInterval = 45.0
        XCTAssertEqual(TestableUtils.getTimeUnitToUse(timeInterval: timeInterval), NSCalendar.Unit.second)
    }
    
    func testRejectNegativeInput() {
        let timeInterval: TimeInterval = -5.0
        XCTAssertNil(TestableUtils.getTimeUnitToUse(timeInterval: timeInterval))
    }
    
    // MARK: User login tests
    
    func testRejectNonMacEmail() {
        XCTAssertFalse(TestableUtils.isMacalesterEmail(email: "example@yahoo.com"))
    }
    
    func testAcceptMacEmail() {
        XCTAssertTrue(TestableUtils.isMacalesterEmail(email: "example@macalester.edu"))
    }
    
    func testCaseInsensitive() {
        XCTAssertTrue(TestableUtils.isMacalesterEmail(email: "example@MaCaLeStEr.EdU"))
    }
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
