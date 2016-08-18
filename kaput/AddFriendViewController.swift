//
//  AddFriendViewController.swift
//  kaput
//
//  Created by OPE50 Team on 11/06/2016.
//  Copyright © 2016 OPE50. All rights reserved.

import UIKit
import FirebaseAuth
import Firebase
import FirebaseDatabase

class AddFriendViewController: UIViewController {
    @IBOutlet var yourUsername: UILabel!
    @IBOutlet var friendNameField: kaputField!
    @IBOutlet var addFriendButton: kaputPrimaryButton!
    @IBAction func addFriend(sender: AnyObject) {
    
        if reachable == true {
        
    Errors.clearErrors(friendNameField)

        
    let name = friendNameField.text!
            
    FirebaseDataService.getUidWithUsername(name,response: {(uid,exists)->() in
        
        if exists && name != ""{
        let inputsOutputs = [name:true] as [String:Bool]
            let myName = [myUsername:true] as [String:Bool]
        ref.child("Users").child(userID).child("friends").updateChildValues(inputsOutputs)
        
            FirebaseDataService.sendFriendRequestToName(name)
            
        ref.child("Users").child(uid).child("friends").updateChildValues(myName)
        self.addFriendButton.titleLabel?.text = "\(name) WAS ADDED"
        self.addFriendButton.backgroundColor = KaputStyle.fullGreen
        
        delay(1.5) {
        self.addFriendButton.titleLabel?.text = "HERE WE GO!"
        self.addFriendButton.backgroundColor = Colors.init().primaryColor
        }
        
    } else {
        
        Errors.errorMessage("YOU SURE ?",field: self.friendNameField)
        self.addFriendButton.animation = "shake"
        self.addFriendButton.animate()  
        
    }
        
    })
        }else{
            notification.notificationLabelBackgroundColor = KaputStyle.lowRed
            notification.displayNotificationWithMessage("DUDE! GET A CONNECTION!", forDuration: 3.0)
        }
    
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        yourUsername.text = "YOUR USERNAME IS \(myUsername)"
        view.backgroundColor = Colors.init().bgColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
            super.touchesBegan(touches, withEvent:event)
        view.endEditing(true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
