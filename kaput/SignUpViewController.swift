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


//n'a rien n'a foutre la.
class User: NSObject {
    var username: String
    
    init(username: String) {
        self.username = username
    }
    
    convenience override init() {
        self.init(username:  "")
    }
}


class SignUpViewController: UIViewController, UITextFieldDelegate {
    

    @IBOutlet weak var usernameField: kaputField!
    @IBOutlet weak var passwordField: kaputField!
    @IBOutlet weak var emailField: kaputField!
    @IBOutlet var signUpButton: kaputButton!
    @IBAction func signUpButton(sender: AnyObject) {
        
        if reachable == true {
       
        
        Errors.clearErrors(emailField)
        Errors.clearErrors(usernameField)
        Errors.clearErrors(passwordField)

        
        signUpButton.animation = "shake"

        let username: String? = self.usernameField.text
        let email = self.emailField.text
        let password = self.passwordField.text
        
        
        ref.child("Users").queryOrderedByChild("name").queryEqualToValue(username).observeEventType(.Value, withBlock: { snapshot in
            if snapshot.exists() == true {
                
                 self.errorAlert("Opps!", message: "username elready taken!")
                
            } else {
                
                 self.errorAlert("Great", message: "username is free")
        }
            
            
            
            }, withCancelBlock: { error in
                
                print(error.localizedDescription)
                
        })
       
        
        
        // verify signup information
        
        var error = false
        
        
        if username == "" {
            Errors.errorMessage("REQUIRED",field: self.usernameField)
            error = true

        }
          else if username?.characters.count<5 {
            Errors.errorMessage("5 CHAR MIN",field: self.usernameField)
            error = true
        }
        if email == "" {
            Errors.errorMessage("REQUIRED",field: self.emailField)
            error = true


        }else if Errors.validateEmail(email!) == false {
            Errors.errorMessage("INVALID MAIL",field: self.emailField)
            error = true

        }
        if password == "" {
            Errors.errorMessage("REQUIRED",field: self.passwordField)
            error = true

        }else if password?.characters.count<4{
            Errors.errorMessage("4 CHAR MIN",field: self.passwordField)
            error = true

        }
        
        
        if !error{
            // set spinner
            
          
            
            
            signUpButton.titleLabel?.text = ""
            let spinner: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(self.view.frame.size.width/2-40,signUpButton.frame.origin.y,80,80))as UIActivityIndicatorView
            self.view.addSubview(spinner)
            spinner.startAnimating()
            
            FIRAuth.auth()?.createUserWithEmail(email!, password: password!){(user,error) in
                spinner.stopAnimating()
                if let error = error{
                    self.errorAlert("Opps!", message:"\(error.localizedDescription)")
                }else{
        
                    userID = String(FIRAuth.auth()!.currentUser!.uid)
                    print("user created")
                    print(email!)
                    FirebaseDataService.createUserData(userID, bat: String(batteryLevel), username: username!)
                    self.performSegueWithIdentifier("toFriendList", sender: self)



                }
                
            }
            
        }
    
        } else {
            notification.notificationLabelBackgroundColor = KaputStyle.lowRed
            notification.displayNotificationWithMessage("DUDE! GET A CONNECTION!", forDuration: 3.0)
            
        }
    
    }
    
    
   override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toFriendList" {
            print("prepareforsegue is called")

  
 


            
        }
    }
    
    
    override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = Colors.init().bgColor
    usernameField.delegate = self
    passwordField.delegate = self
    emailField.delegate = self

        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    // setup alert
    func errorAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    
    //inutile
    func sccuessAlert(title: String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
        
    }
    
    
    
    func textFieldDidBeginEditing(textField: UITextField) {
       
        switch textField {
        case usernameField:
            Errors.clearErrors(usernameField)
        
        case passwordField:
            Errors.clearErrors(passwordField)

        case emailField:
            Errors.clearErrors(emailField)
        default: break
        }
        
        
    }
    
    


}
