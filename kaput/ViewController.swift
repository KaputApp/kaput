//
//  ViewController.swift
//  kaput
//
//  Created by Noémie Rebibo on 26/05/2016.
//  Copyright © 2016 OPE50. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {


    @IBOutlet weak var labelBattery: UILabel!
    override func viewDidLoad() {
        
        //Shows the level battery on the welcom screen
        UIDevice.currentDevice().batteryMonitoringEnabled = true
        let batteryLevel = Int((abs(UIDevice.currentDevice().batteryLevel) * 100))
        labelBattery.text = String(batteryLevel) + "%"
        

        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

