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

let ref = FIRDatabase.database().reference()
var userID = String(FIRAuth.auth()!.currentUser!.uid)


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
    

    
    // setup alert
    func errorAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func sccuessAlert(title: String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func signUpButton(sender: AnyObject) {
        let username: String? = self.usernameField.text
        let email = self.emailField.text
        let password = self.passwordField.text
        //refresh textfiled
        let finalemail = email!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        let finalpassword = password!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        let finalusername = username?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        
        

        
        
        // verify signup information
        if username?.characters.count<5 {
            self.errorAlert("Opps!", message: "username must longer than 5 characters!")
        } else if email?.characters.count<8 {
            self.errorAlert("Opps!", message: "Please enter vaild email address!")
        }else if password?.characters.count<8{
            self.errorAlert("Opps!", message: "Your password must larger than 8 characters!")
            
        }
        else {
            // set spinner
            let spinner: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0,0,80,80))as UIActivityIndicatorView
            self.view.addSubview(spinner)
            spinner.startAnimating()
            FIRAuth.auth()?.createUserWithEmail(email!, password: password!){(user,error) in
                spinner.stopAnimating()
                if let error = error{
                    self.errorAlert("Opps!", message:"\(error.localizedDescription)")
                }else{
                    self.sccuessAlert("Sccuess", message: "User created!")
                    ref.child("Users").child(userID).setValue(["userID": userID, "batteryLevel": batteryLevel, "isOnLine": "true", "name":String(username!)])
                    dispatch_async(dispatch_get_main_queue(), {()-> Void in
                        
                        let loginViewController = self.storyboard!.instantiateViewControllerWithIdentifier("friendListView")
                        UIApplication.sharedApplication().keyWindow?.rootViewController = loginViewController
                        
                    })
                }
                
            }
            
        }
    
}
      override func viewDidLoad() {
        super.viewDidLoad()
        usernameField.becomeFirstResponder()
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
