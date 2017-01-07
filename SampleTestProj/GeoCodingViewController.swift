//
//  GeoCodingViewController.swift
//  SampleTestProj
//
//  Created by bibek timalsina on 1/7/17.
//  Copyright © 2017 bibek. All rights reserved.
//

import UIKit

class GeoCodingViewController: UIViewController {
    
    @IBOutlet weak var lblLocation: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    func setup() {
         NotificationCenter.default.addObserver(self, selector: #selector(locationUpdated), name: Notification.Name(rawValue:LocationManager.Constants().locationUpdated), object: nil)
    }
    
    func locationUpdated() {
        LocationManager.shared.reverseGeocodeCurrentLocation { (placemarks, error) in
            if let error = error {
                self.lblLocation.text = error.localizedDescription
            }else {
                guard let placemark = placemarks?.first else {
                    self.lblLocation.text = "error"
                    return
                }
                
                let text = " admininstrative area: \(placemark.administrativeArea ?? "") \n postal code: \(placemark.postalCode ?? "") \n locality: \(placemark.locality ?? "")"
                self.lblLocation.text = text
            }
        }
    }
    
}
