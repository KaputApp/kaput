//
//  SignInViewController.swift
//  kaput
//
//  Created by Jeremy OUANOUNOU on 01/06/2016.
//  Copyright © 2016 OPE50. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase




class SignInViewController: UIViewController, UITextFieldDelegate {
    


    
    @IBOutlet weak var emailField: kaputField!
    @IBAction func resetPassword(sender: AnyObject) {
        
            let email = self.emailField.text
        Errors.clearErrors(emailField)
        Errors.clearErrors(passwordField)
        
        
        var error = false
        
        if email == "" {
        Errors.errorMessage("REQUIRED",field: self.emailField)
        error = true
            
            
        } else if Errors.validateEmail(email!) == false {
            Errors.errorMessage("INVALID MAIL",field: self.emailField)
            error = true
            
        }
        
        
        if !error {
        
            let finalemail = email?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            FIRAuth.auth()?.sendPasswordResetWithEmail(email!, completion: nil)
            let  alert = UIAlertController(title: "Password resrt!", message: "An email containing information on how to reset your password has been sent to  \(finalemail!)", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    @IBOutlet weak var passwordField: kaputField!
    
    func errorAlert(title: String, message: String) {
        weak var emailField: kaputField!
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
    
   
    
    @IBAction func logInButton(sender: AnyObject) {
        
        
        Errors.clearErrors(emailField)
        Errors.clearErrors(passwordField)

        
        var email = self.emailField.text
        var password = self.passwordField.text
        email = email!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        password = password!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
     
        var error = false
        
        if email == "" {
            Errors.errorMessage("REQUIRED",field: self.emailField)
            error = true
            
            
        } else if Errors.validateEmail(email!) == false {
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

        
        
        if !error {
        
            let spinner: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0,0,80,80)) as UIActivityIndicatorView
            self.view.addSubview(spinner)
            spinner.startAnimating()
            FIRAuth.auth()?.signInWithEmail(email!, password: password!){(user,error) in
                spinner.stopAnimating()
                if error != nil {
                    self.errorAlert("Opps!", message:"Wrong username or password")
                }else{
                    self.view.endEditing(true)

                
                    self.performSegueWithIdentifier("FriendList", sender: self)
                    
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailField.delegate = self
        passwordField.delegate = self
        
        view.backgroundColor = Colors.init().bgColor
        


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func textFieldDidBeginEditing(textField: UITextField) {
        
        switch textField {
               case passwordField:
            Errors.clearErrors(passwordField)
            
        case emailField:
            Errors.clearErrors(emailField)
        default: break
        }
    }
}
