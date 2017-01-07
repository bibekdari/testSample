//
//  AppDelegateTest.swift
//  SampleTestProj
//
//  Created by bibek timalsina on 1/7/17.
//  Copyright © 2017 bibek. All rights reserved.
//

import XCTest
@testable import SampleTestProj

class AppDelegateTest: XCTestCase {
    
    let appDelegate = SampleTestProj.appDelegate
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testFirstAppLaunchCoordinate() {
        XCTAssertNotNil(appDelegate.firstLocationOfApp)
    }
    
    
    
}
