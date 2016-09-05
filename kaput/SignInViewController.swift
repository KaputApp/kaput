//
//  SignInViewController.swift
//  kaput
//
//  Created by OPE50 Team on 01/06/2016.
//  Copyright © 2016 OPE50. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FBSDKLoginKit


class SignInViewController: UIViewController, UITextFieldDelegate {


    @IBAction func loginFB(sender: AnyObject) {
        
        if reachable == true {
            
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
                            
                            // on verifie si l'arbo dédiée a mon user existe déja
                            ref.child("Users").child(userID).observeSingleEventOfType(FIRDataEventType.Value, withBlock: { (snapshot) in
                                //Si oui, on passe l'étape
                                if snapshot.hasChildren(){
                                    self.performSegueWithIdentifier("FriendList", sender: self)
                                    userID = String(FIRAuth.auth()!.currentUser!.uid)
                                } else {
                                    //Si non, créer l'user et on passe l'étape
                                    self.performSegueWithIdentifier("pickUsername", sender: self)
                                    FirebaseDataService.createUserData(userID, bat: String(batteryLevel), username: "", kaputSent: 0)
                                    FirebaseDataService.getAvatarFromFB({(image) in
                                        FirebaseDataService.storeAvatarInFirebase(image)
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
    @IBOutlet weak var emailField: kaputField!
    @IBAction func resetPassword(sender: AnyObject) {
        
        if reachable == true {
        
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
            let  alert = UIAlertController(title: "Password reset!", message: "An email containing information on how to reset your password has been sent to  \(finalemail!)", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        } else {
            notification.notificationLabelBackgroundColor = KaputStyle.lowRed
            notification.displayNotificationWithMessage("DUDE! GET A CONNECTION!", forDuration: 3.0)
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
        
        if reachable == true {
        
        
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
        } else if password!.rangeOfCharacterFromSet(letters.invertedSet) != nil {
            Errors.errorMessage("ONLY ALPHA NUMERIC",field: self.passwordField)
            error = true
            }
            
        else if password?.characters.count<4{
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
                    self.errorAlert("Opps!", message:"Wrong username or password \(error)")
                }else{
                    self.view.endEditing(true)

                    userID = String(FIRAuth.auth()!.currentUser!.uid)
                    FirebaseDataService.getName({(name) in
                        myUsername = name
                    })
            
                    FirebaseDataService.getAvatarFromFirebase({(image) in
                        myAvatar = image
                    })

                
                    self.performSegueWithIdentifier("FriendList", sender: self)
                    
                }
            }
        }
        } else {
            notification.notificationLabelBackgroundColor = KaputStyle.lowRed
            notification.displayNotificationWithMessage("DUDE! GET A CONNECTION!", forDuration: 3.0)
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
