//
//  AddFriendViewController.swift
//  kaput
//
//  Created by Jeremy OUANOUNOU on 11/06/2016.
//  Copyright © 2016 OPE50. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseDatabase

class AddFriendViewController: UIViewController {
    @IBOutlet var friendNameField: kaputField!
    @IBAction func addFriend(sender: AnyObject) {
        
        let inputsOutputs = [friendNameField.text!:true] as [String:Bool]
       ref.child("Users/xy2olnrUo2Wa5FY59c6KXIY4on62/friends").updateChildValues(inputsOutputs)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Colors.init().bgColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
