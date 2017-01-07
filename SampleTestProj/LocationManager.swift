//
//  LocationManager.swift
//  SampleTestProj
//
//  Created by bibek timalsina on 1/7/17.
//  Copyright © 2017 bibek. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationManagerDelegate {
    var thresholdDistance: Double {get}
}

class LocationManager: NSObject {
    
    struct Constants {
        let locationUpdated = "LocationMangerLocationUpdated"
        let locationThresholdDistanceMet = "LocationManagerThresholdDistanceMet"
    }
    
    static let shared: LocationManager = LocationManager()
    
    let geoCoder = CLGeocoder()
    
    var delegate: LocationManagerDelegate?
    
    var currentLocation: CLLocation? {
        didSet {
            
            let constants = Constants()
            fireNotification(name: constants.locationUpdated)
            
            if oldValue == nil && currentLocation != nil {
                fiftyMeterLocation = currentLocation
            }
            
            checkIfLocationCrossed()
        }
    }
    
    var fiftyMeterLocation: CLLocation?
    
    let manager: CLLocationManager?
    
    override init() {
        manager = CLLocationManager()
        super.init()
        manager?.requestAlwaysAuthorization()
        manager?.desiredAccuracy =  kCLLocationAccuracyNearestTenMeters
        manager?.delegate = self
        manager?.startUpdatingLocation()
    }
    
    func checkIfLocationCrossed() {
        let constants = Constants()
        
        guard let oldFiftyMeterLocation = fiftyMeterLocation, let newLocation = currentLocation, let thresholdDistance = delegate?.thresholdDistance else {return}
        
        let distance = oldFiftyMeterLocation.distance(from: newLocation) // in meters
        
        if distance >=  thresholdDistance {
            fireNotification(name: constants.locationThresholdDistanceMet, userInfo: nil)
            fiftyMeterLocation = newLocation
        }
    }
    
    func fireNotification(name: String, userInfo: [String: Any]? = nil) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: name), object: nil, userInfo: userInfo)
    }
    
    func distanceToCurrentLocation(from location: CLLocation) -> Double {
        return currentLocation?.distance(from: location) ?? 0.0
    }
    
    func reverseGeocodeCurrentLocation(_ completion: @escaping CLGeocodeCompletionHandler) {
        guard let currentLocation = currentLocation else {return}
        self.reverseGeoCode(location: currentLocation, completion: completion)
    }
    
    func reverseGeoCode(location: CLLocation, completion: @escaping CLGeocodeCompletionHandler) {
        geoCoder.reverseGeocodeLocation(location, completionHandler: completion)
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.currentLocation = locations.last
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error updating location: \(error.localizedDescription)")
    }
}
