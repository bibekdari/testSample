//
//  RecordsViewController.swift
//  SampleTestProj
//
//  Created by bibek timalsina on 1/7/17.
//  Copyright © 2017 bibek. All rights reserved.
//

import UIKit

class RecordsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var dates = [Date]()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    func setup() {
        let userDefault = UserDefaults.standard
        let key = "thresholdCrossedDateTimes"
        
        self.dates = (userDefault.array(forKey: key) as? [Date]) ?? []
        
        tableView.dataSource = self
        
         NotificationCenter.default.addObserver(self, selector: #selector(thresholdDistanceCrossed), name: Notification.Name(rawValue:LocationManager.Constants().locationThresholdDistanceMet), object: nil)
    }
    
    func thresholdDistanceCrossed() {
        dates.append(Date())
        self.tableView.reloadData()
    }

}

extension RecordsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let date = dates[indexPath.row]
        cell.textLabel?.text = "\(date)"
        return cell
    }
}
