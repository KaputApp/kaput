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


class SignUpViewController: UIViewController {

    @IBOutlet weak var usernameField: kaputField!
    
    @IBOutlet weak var passwordField: kaputField!
    
    @IBOutlet weak var emailField: kaputField!
    
    @IBAction func signUpButton(sender: AnyObject) {
        let username = usernameField.text
        let email = emailField.text
        let password = passwordField.text
        FIRAuth.auth()?.createUserWithEmail(email!, password: password!) { (user, error) in
            if let error = error {
                print(error.localizedDescription)
                return
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
