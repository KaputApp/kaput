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
        // a refactorer, le niveau de batterie devrait etre une variable globale.
        UIDevice.currentDevice().batteryMonitoringEnabled = true
        let batteryLevel = abs(UIDevice.currentDevice().batteryLevel);
        
        labelBattery.text = String(Int(batteryLevel*100)) + "%"
        
        
        
        
        
        // setting the height of the bar with a constraint.
        
        let batteryLevelHeight = CGFloat(UIDevice.currentDevice().batteryLevel)*UIScreen.mainScreen().bounds.height
        print("f", batteryLevelHeight)
        chargingBarHeight.constant=batteryLevelHeight
        chargingBarView.needsUpdateConstraints()

        // setting the color of the bar
        
        if batteryLevel < 0.80 {
            chargingBarView.backgroundColor = KaputStyle.lowRed
        }
        else {
            chargingBarView.backgroundColor = KaputStyle.fullGreen
        }
       
        
        buttonLogIn.layer.borderWidth = 5;
        buttonLogIn.layer.borderColor = UIColor.whiteColor().CGColor;
        buttonLogIn.layer.shadowColor = KaputStyle.shadowColor.CGColor;
        buttonLogIn.layer.shadowOffset = CGSizeMake(10, 10);
        buttonLogIn.layer.shadowRadius = 0
        buttonLogIn.layer.shadowOpacity = 1;
        
        
        
        buttonFacebook.layer.borderWidth = 5;
        buttonFacebook.layer.borderColor = UIColor.whiteColor().CGColor;
        buttonFacebook.layer.shadowColor = KaputStyle.shadowColor.CGColor;
        buttonFacebook.layer.shadowOffset = CGSizeMake(10, 10);
        buttonFacebook.layer.shadowRadius = 0
        buttonFacebook.layer.shadowOpacity = 1;
        
        buttonSignUp.layer.borderWidth = 5;
        buttonSignUp.layer.borderColor = UIColor.whiteColor().CGColor;
        buttonSignUp.layer.shadowColor = KaputStyle.shadowColor.CGColor;
        buttonSignUp.layer.shadowOffset = CGSizeMake(10, 10);
        buttonSignUp.layer.shadowRadius = 0
        buttonSignUp.layer.shadowOpacity = 1;
        buttonSignUp.backgroundColor = KaputStyle.chargingBlue;


        

        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

