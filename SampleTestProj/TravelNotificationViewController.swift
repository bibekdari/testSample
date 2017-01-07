//
//  TravelNotificationViewController.swift
//  SampleTestProj
//
//  Created by bibek timalsina on 1/7/17.
//  Copyright © 2017 bibek. All rights reserved.
//

import UIKit

class TravelNotificationViewController: UIViewController {

    @IBOutlet weak var lblDistanceTravelled: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    func setup() {
        NotificationCenter.default.addObserver(self, selector: #selector(locationUpdated), name: Notification.Name(rawValue:LocationManager.Constants().locationUpdated), object: nil)
    }
    
    func locationUpdated() {
        let distanceText: String
        if let firstLocation = appDelegate.firstLocationOfApp {
            let distanceCovered = LocationManager.shared.distanceToCurrentLocation(from: firstLocation)
            distanceText = "\(round(distanceCovered))m"
            
        }else {
            distanceText = "0.0m"
        }
        
        lblDistanceTravelled.text = distanceText
    }

}
