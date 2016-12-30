//
//  ViewController.swift
//  kaput
//
//  Created by OPE50 Team on 26/05/2016.
//  Copyright © 2016 OPE50. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FBSDKLoginKit
import FBSDKCoreKit


@IBDesignable


class ViewController: UIappViewController {

    
//declarations of outlets
    
    @IBAction func facebookLogin(_ sender: AnyObject) {
        
        if reachable == true {
        
        let facebookLogin = FBSDKLoginManager()

        
        facebookLogin.logIn(withReadPermissions: ["public_profile", "email","user_friends"], from: self, handler: {
            (facebookResult, facebookError) -> Void in
            if facebookError != nil {
                print("Facebook login failed. Error \(facebookError)")
            } else if (facebookResult?.isCancelled)! {
                print("Facebook login was cancelled.")
            } else {
                
            let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                
            FIRAuth.auth()?.signIn(with: credential) { (user, error) in
                    if error != nil {
                    print("Login failed. \(error)")
                    } else {
                    print("Logged in!")

                        // on verifie si l'arbo dédiée a mon user existe déja
                        ref.child("Users").child(userID!).observeSingleEvent(of: FIRDataEventType.value, with: { (snapshot) in
                        //Si oui, on passe l'étape
                            if snapshot.hasChildren(){
                        self.performSegue(withIdentifier: "facebookLoginSegue", sender: self)
                        userID = String(FIRAuth.auth()!.currentUser!.uid)
                            } else {
                        //Si non, créer l'user et on passe l'étape
                            self.performSegue(withIdentifier: "pickUsernameSegue", sender: self)
                                FirebaseDataService.createUserData(userID!, bat: String(batteryLevel), username: "", kaputSent: 0)
                                FirebaseDataService.getAvatarFromFB({(image) in
                                FirebaseDataService.storeAvatarInFirebase(image)
                                let imageData = UIImageJPEGRepresentation(image, 0.8)
                                let compressedImageFB = UIImage(data : imageData!)
                                myAvatar = compressedImageFB!
                                })
                                
                            }

                        })
    
            }}
            }
        }
    
            )} else {
            notification.notificationLabelBackgroundColor = KaputStyle.lowRed
            notification.displayNotificationWithMessage("DUDE! GET A CONNECTION!", forDuration: 3.0)
        }
    
    }
    
@IBOutlet var buttonFacebook: SpringButton!
@IBOutlet var buttonLogIn: SpringButton!
@IBOutlet var buttonSignUp: SpringButton!
@IBOutlet var chargingBarView: UIView!
@IBOutlet var chargingBarHeight: NSLayoutConstraint!
@IBOutlet weak var labelBattery: SpringLabel!

    @IBOutlet var labelTag: SpringLabel!
    override func viewDidLoad()
    
    {
        // setting the height of the bar with a constraint.
        print("INITIALISATION")
        print(myAvatar)
        print(myUsername)
        print("END INIT")

        
        batLevel.init()
        
        self.labelTag.text =  Colors.init().label

        NotificationCenter.default.addObserver(self, selector: #selector(self.batteryLevelDidChange(_:)), name:NSNotification.Name.UIDeviceBatteryLevelDidChange, object: nil)
          NotificationCenter.default.addObserver(self, selector: #selector(self.batteryStateDidChange(_:)), name:NSNotification.Name.UIDeviceBatteryStateDidChange, object: nil)

        chargingBarView.backgroundColor = Colors.init().bgColor
        let batteryLevelHeight = CGFloat(UIDevice.current.batteryLevel)*UIScreen.main.bounds.height

        chargingBarHeight.constant=batteryLevelHeight
        chargingBarView.frame.origin.y = UIScreen.main.bounds.height
        print(chargingBarView.frame.origin.y)

        UIView.animate(withDuration: 2, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
        
        self.chargingBarView.needsUpdateConstraints()
        self.chargingBarView.layoutIfNeeded()
            
        }, completion: nil)
        
        //Shows the level battery on the welcom screen
        labelBattery.text = String(batLevel.init().levelBat) + "%"
        
        super.viewDidLoad()
        manager.delegate = self
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func batteryStateDidChange(_ notification: Notification){
       // batLevel.init()
      //  Colors.init()
      //  viewDidLoad()
    }

    func batteryLevelDidChange(_ notification: Notification){
        batLevel.init()
        Colors.init()
        viewDidLoad()
    }
    


    
}

