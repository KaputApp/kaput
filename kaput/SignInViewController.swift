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
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}



class SignInViewController: UIViewController, UITextFieldDelegate {


    @IBAction func loginFB(_ sender: AnyObject) {
        
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
                                    self.performSegue(withIdentifier: "FriendList", sender: self)
                                    userID = String(FIRAuth.auth()!.currentUser!.uid)
                                } else {
                                    //Si non, créer l'user et on passe l'étape
                                    self.performSegue(withIdentifier: "pickUsername", sender: self)
                                    FirebaseDataService.createUserData(userID!, bat: String(batteryLevel), username: "", kaputSent: 0)
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
    @IBAction func resetPassword(_ sender: AnyObject) {
        
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
        
            let finalemail = email?.trimmingCharacters(in: CharacterSet.whitespaces)
            FIRAuth.auth()?.sendPasswordReset(withEmail: email!, completion: nil)
            let  alert = UIAlertController(title: "Password reset!", message: "An email containing information on how to reset your password has been sent to  \(finalemail!)", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        } else {
            notification.notificationLabelBackgroundColor = KaputStyle.lowRed
            notification.displayNotificationWithMessage("DUDE! GET A CONNECTION!", forDuration: 3.0)
        }
    }
    
    @IBOutlet weak var passwordField: kaputField!
    
    func errorAlert(_ title: String, message: String) {
        weak var emailField: kaputField!
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func sccuessAlert(_ title: String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
   
    
    @IBAction func logInButton(_ sender: AnyObject) {
        
        if reachable == true {
        
        
        Errors.clearErrors(emailField)
        Errors.clearErrors(passwordField)

        
        var email = self.emailField.text
        var password = self.passwordField.text
        email = email!.trimmingCharacters(in: CharacterSet.whitespaces)
        password = password!.trimmingCharacters(in: CharacterSet.whitespaces)
     
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
        } else if password!.rangeOfCharacter(from: letters.inverted) != nil {
            Errors.errorMessage("ONLY ALPHA NUMERIC",field: self.passwordField)
            error = true
            }
            
        else if password?.characters.count<4{
            Errors.errorMessage("4 CHAR MIN",field: self.passwordField)
            error = true
            
        }

        if !error {
        
            let spinner: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 0,y: 0,width: 80,height: 80)) as UIActivityIndicatorView
            self.view.addSubview(spinner)
            spinner.startAnimating()
            FIRAuth.auth()?.signIn(withEmail: email!, password: password!){(user,error) in
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

                
                    self.performSegue(withIdentifier: "FriendList", sender: self)
                    
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
    

    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        switch textField {
               case passwordField:
            Errors.clearErrors(passwordField)
            
        case emailField:
            Errors.clearErrors(emailField)
        default: break
        }
    }
}
