//
//  SettingsTableViewController.swift
//  The Weather App
//
//  Created by yusuf_kildan on 17/06/2016.
//  Copyright © 2016 yusuf_kildan. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if NSUserDefaults.standardUserDefaults().valueForKey("state") != nil {
        let condVal =  NSUserDefaults.standardUserDefaults().valueForKey("state") as! Bool
          swich.setOn(condVal, animated: true)
            
        }
        tableView.tableFooterView = UIView()
    }
    @IBOutlet weak var swich : UISwitch!
   
    @IBAction func switchAction(sender: UISwitch) {
        if swich.on {
            isMetric = true
            NSUserDefaults.standardUserDefaults().setValue(true, forKey: "state")
        }else {
            isMetric = false
            NSUserDefaults.standardUserDefaults().setValue(false, forKey: "state")
        }
    }
}
