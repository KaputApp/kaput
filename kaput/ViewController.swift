//
//  ViewController.swift
//  kaput
//
//  Created by Noémie Rebibo on 26/05/2016.
//  Copyright © 2016 OPE50. All rights reserved.
//

import UIKit
import Firebase
@IBDesignable


class ViewController: UIViewController {
    
    
//declarations of outlets
    
@IBOutlet var buttonFacebook: UIButton!
@IBOutlet var buttonLogIn: UIButton!
@IBOutlet var buttonSignUp: UIButton!
@IBOutlet var chargingBarView: UIView!
@IBOutlet var chargingBarHeight: NSLayoutConstraint!
@IBOutlet weak var labelBattery: UILabel!


    override func viewDidLoad()
    
    {
        
        //Shows the level battery on the welcom screen
        labelBattery.text = String(batteryLevel) + "%"
        
        
        
        
        
        // setting the height of the bar with a constraint.
        
        let batteryLevelHeight = CGFloat(UIDevice.currentDevice().batteryLevel)*UIScreen.mainScreen().bounds.height
        print("f", batteryLevelHeight)
        chargingBarHeight.constant=batteryLevelHeight
        chargingBarView.needsUpdateConstraints()

        // setting the color of the bar
        
        if batteryLevel < 80 {
            chargingBarView.backgroundColor = KaputStyle.lowRed
        }
        else {
            chargingBarView.backgroundColor = KaputStyle.fullGreen
        }
               buttonSignUp.backgroundColor = KaputStyle.chargingBlue;


        

        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

