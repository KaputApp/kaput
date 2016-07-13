//
//  ViewController.swift
//  kaput
//
//  Created by Noémie Rebibo on 26/05/2016.
//  Copyright © 2016 OPE50. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FBSDKLoginKit
import FBSDKCoreKit


@IBDesignable


class ViewController: UIViewController {
    
    
//declarations of outlets
    


    
    @IBAction func facebookLogin(sender: AnyObject) {
        
        let facebookLogin = FBSDKLoginManager()

       
        facebookLogin.logInWithReadPermissions(["public_profile", "email","user_friends"], fromViewController: self, handler: {
            (facebookResult, facebookError) -> Void in
            if facebookError != nil {
                print("Facebook login failed. Error \(facebookError)")
            } else if facebookResult.isCancelled {
                print("Facebook login was cancelled.")
            } else {
                
                let credential = FIRFacebookAuthProvider.credentialWithAccessToken(FBSDKAccessToken.currentAccessToken().tokenString)
                
                FIRAuth.auth()?.signInWithCredential(credential) { (user, error) in
                    if error != nil {
                        print("Login failed. \(error)")
                    } else {
                        print("Logged in!")
                        
                    FirebaseDataService.createUserData(userID, bat: String(batteryLevel), username: (user?.displayName)!)
                        self.performSegueWithIdentifier("facebookLoginSegue", sender: self)
                        
                    }
                }
            }
        })
    }
    
@IBOutlet var buttonFacebook: SpringButton!
@IBOutlet var buttonLogIn: SpringButton!
@IBOutlet var buttonSignUp: SpringButton!
@IBOutlet var chargingBarView: UIView!
@IBOutlet var chargingBarHeight: NSLayoutConstraint!
@IBOutlet weak var labelBattery: SpringLabel!


    override func viewDidLoad()
    
    {
        
        // setting the height of the bar with a constraint.
        
        batLevel.init()

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.batteryLevelDidChange(_:)), name:UIDeviceBatteryLevelDidChangeNotification, object: nil)
          NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.batteryStateDidChange(_:)), name:UIDeviceBatteryStateDidChangeNotification, object: nil)

        chargingBarView.frame.origin.y = UIScreen.mainScreen().bounds.height
        chargingBarView.backgroundColor = Colors.init().bgColor
        let batteryLevelHeight = CGFloat(UIDevice.currentDevice().batteryLevel)*UIScreen.mainScreen().bounds.height
       
        
        chargingBarHeight.constant=batteryLevelHeight
        
        UIView.animateWithDuration(2, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
        
        self.chargingBarView.needsUpdateConstraints()
        self.chargingBarView.layoutIfNeeded()
        }, completion: nil)

        
        
        //Shows the level battery on the welcom screen
        labelBattery.text = String(batLevel.init().levelBat) + "%"
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func batteryStateDidChange(notification: NSNotification){
       // batLevel.init()
      //  Colors.init()
      //  viewDidLoad()
    }

    func batteryLevelDidChange(notification: NSNotification){
        batLevel.init()
        Colors.init()
        viewDidLoad()
    }
 
    
}

