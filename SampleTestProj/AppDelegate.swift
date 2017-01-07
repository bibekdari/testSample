//
//  AppDelegate.swift
//  SampleTestProj
//
//  Created by bibek timalsina on 1/7/17.
//  Copyright © 2017 bibek. All rights reserved.
//

import UIKit
import CoreLocation
import UserNotifications

var appDelegate: AppDelegate {
    return UIApplication.shared.delegate as! AppDelegate
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, LocationManagerDelegate {
    
    var window: UIWindow?
    
    var thresholdDistance: Double = 50 // meters
    
    var firstLocationOfApp: CLLocation?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        LocationManager.shared.delegate = self
        
        // setup user notification authorization
        UNUserNotificationCenter.current().requestAuthorization(options: [.sound, .alert]) { (success, error) in
            print(error?.localizedDescription ?? "Success")
        }
        
        // listen to location update notifications
        NotificationCenter.default.addObserver(self, selector: #selector(thresholdDistanceCrossed), name: Notification.Name(rawValue:LocationManager.Constants().locationThresholdDistanceMet), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(locationUpdated), name: Notification.Name(rawValue:LocationManager.Constants().locationUpdated), object: nil)
        
        return true
    }
    
    func locationUpdated() {
        if firstLocationOfApp == nil {
            firstLocationOfApp = LocationManager.shared.currentLocation
        }
    }
    
    func thresholdDistanceCrossed() {
        updatePersistent()
        
        // show notification
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "50 meter crossed"
        notificationContent.body = "You crossed 50 m"
        notificationContent.sound = UNNotificationSound.default()
        
        let request = UNNotificationRequest(identifier: "50_Meter_Crossed", content: notificationContent, trigger: nil)
        
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        center.add(request) { (error) in
            print(error?.localizedDescription ?? "Notification fired")
        }
    }
    
    // update date time in persistent
    func updatePersistent() {
        let userDefault = UserDefaults.standard
        let key = "thresholdCrossedDateTimes"
        let dates: [Date]
        
        if let dateTime = userDefault.array(forKey: key) as? [Date] {
            dates = dateTime + [Date()]
        }else {
            dates = [Date()]
        }
        
        userDefault.set(dates, forKey: key)
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    // show notification in foreground also
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.sound, .alert])
    }
}


