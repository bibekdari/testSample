//
//  LocationManagerTest.swift
//  SampleTestProj
//
//  Created by bibek timalsina on 1/7/17.
//  Copyright © 2017 bibek. All rights reserved.
//

import XCTest
import CoreLocation

@testable import SampleTestProj

class LocationManagerTest: XCTestCase {
    
    let locationManager = LocationManager.shared
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAuthorization() {
        let exp = [.authorizedAlways, .authorizedWhenInUse].contains(CLLocationManager.authorizationStatus())
        XCTAssert(exp)
    }
    
    func testLocationUpdates() {
        XCTAssertNotNil(locationManager.currentLocation)
    }
    
    func testFiftyMeterCrossed() {
        let location1 = CLLocation(latitude: 27.628728, longitude: 85.529591)
        let location2 = CLLocation(latitude: 27.629133, longitude: 85.527757)
        
        locationManager.currentLocation = location1
        locationManager.currentLocation = location2
        
        XCTAssertEqual(location2.coordinate.latitude, locationManager.fiftyMeterLocation?.coordinate.latitude)
        XCTAssertEqual(location2.coordinate.longitude, locationManager.fiftyMeterLocation?.coordinate.longitude)
    }
    
    func testFiftyMeterCrossedShouldNotChangeTwo() {
        let location0 = CLLocation(latitude: 27.629133, longitude: 85.527757)
        let location1 = CLLocation(latitude: 27.628728, longitude: 85.529591)
        let location2 = CLLocation(latitude: 27.628785, longitude: 85.529360)
        
        locationManager.currentLocation = location0
        
        // distance between below two location isn't greater than 50 so fifty meter location must remain location1
        locationManager.currentLocation = location1
        locationManager.currentLocation = location2
        
        XCTAssertEqual(location1.coordinate.latitude, locationManager.fiftyMeterLocation?.coordinate.latitude)
        XCTAssertEqual(location1.coordinate.longitude, locationManager.fiftyMeterLocation?.coordinate.longitude)
    }
    
    func testDistanceToCurrentLocation() {
        let location1 = CLLocation(latitude: 27.626249, longitude: 85.535193)
        let location2 = CLLocation(latitude: 27.626249, longitude: 85.535193)
        
        locationManager.currentLocation = location1
        
        let result =  round(locationManager.distanceToCurrentLocation(from: location2))
        let expectedResult: Double = 0
        
        XCTAssertEqual(result, expectedResult)
    }
    
    func testDistanceToCurrentLocation2() {
        let location1 = CLLocation(latitude: 27.628728, longitude: 85.529591)
        let location2 = CLLocation(latitude: 27.629133, longitude: 85.527757)
        
        locationManager.currentLocation = location1
        
        let result =  round(locationManager.distanceToCurrentLocation(from: location2))
        let expectedResult: Double = 186
        
        XCTAssertEqual(result, expectedResult)
    }
    
}
