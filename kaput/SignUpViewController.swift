//
//  SignUpViewController.swift
//  kaput
//
//  Created by Jeremy OUANOUNOU on 01/06/2016.
//  Copyright © 2016 OPE50. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseDatabase



class User: NSObject {
    var username: String
    
    init(username: String) {
        self.username = username
    }
    
    convenience override init() {
        self.init(username:  "")
    }
}


class SignUpViewController: UIViewController {

    @IBOutlet weak var usernameField: kaputField!
    
    @IBOutlet weak var passwordField: kaputField!
    
    @IBOutlet weak var emailField: kaputField!
    
    @IBAction func signUpButton(sender: AnyObject) {
        var ref:FIRDatabaseReference!
       
        ref = FIRDatabase.database().reference()
        let username  = usernameField.text! as NSString
        let email = emailField.text
        let password = passwordField.text
       
        FIRAuth.auth()?.createUserWithEmail(email!, password: password!) { (user, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
           let user = FIRAuth.auth()?.currentUser
           let uid = user?.uid
            

            FIRDatabase.database().reference().child("users").child(uid!).setValue(["username": username])
            
            ref.child("users").child(uid!).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                // Get user value
                let username2 = snapshot.value!["username"] as! String
                print(username2)
                // ...
            }) { (error) in
                print(error.localizedDescription)
            }

            
            
        }
    }
    
    
    
    
    
      override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
