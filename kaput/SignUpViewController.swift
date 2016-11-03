//
//  SignUpViewController.swift
//  kaput
//
//  Created by OPE50 Team on 01/06/2016.
//  Copyright © 2016 OPE50. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
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
                                    
                                    FirebaseDataService.getName({(name) in
                                        myUsername = name
                                    })
                                    
                                    self.performSegue(withIdentifier: "toFriendList", sender: self)
                                    userID = String(FIRAuth.auth()!.currentUser!.uid)
                                    
                                } else {
                                    //Si non, créer l'user et on passe l'étape
                                    self.performSegue(withIdentifier: "pickUsernameSegue", sender: self)
                                    FirebaseDataService.createUserData(userID!, bat: String(batteryLevel), username: "", kaputSent: 0)
                                    FirebaseDataService.getAvatarFromFB({(image) in
                                        FirebaseDataService.storeAvatarInFirebase(image)
                                        myAvatar = image
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
    
    
    @IBOutlet var signUpButton: kaputButton!
    @IBAction func signUpButton(_ sender: AnyObject) {
        
        if reachable == true {
       
        
        Errors.clearErrors(emailField)
        Errors.clearErrors(usernameField)
        Errors.clearErrors(passwordField)

        
        signUpButton.animation = "shake"

        let username: String? = self.usernameField.text
        let email = self.emailField.text
        let password = self.passwordField.text
        
        
        ref.child("Users").queryOrdered(byChild: "name").queryEqual(toValue: username).observe(.value, with: { snapshot in
            if snapshot.exists() == true {
                
                Errors.errorMessage("ALREADY TAKEN",field: self.usernameField)
                
                
            } else {
                
                var error = false
                
                if username == "" {
                    Errors.errorMessage("REQUIRED",field: self.usernameField)
                    error = true
                    
                }
                else if username?.characters.count<4 {
                    Errors.errorMessage("4 CHAR MIN",field: self.usernameField)
                    error = true
                }
                else if username?.rangeOfCharacter(from: letters.inverted) != nil {
                    Errors.errorMessage("ONLY ALPHA NUMERIC",field: self.usernameField)
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
                    
                    self.signUpButton.titleLabel?.text = ""
                    let spinner: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: self.view.frame.size.width/2-40,y: self.signUpButton.frame.origin.y,width: 80,height: 80))as UIActivityIndicatorView
                    self.view.addSubview(spinner)
                    spinner.startAnimating()
                    
                    FIRAuth.auth()?.createUser(withEmail: email!, password: password!){(user,error) in
                        spinner.stopAnimating()
                        if let error = error{
                            self.errorAlert("Opps!", message:"\(error.localizedDescription)")
                        }else{
                            
                            userID = String(FIRAuth.auth()!.currentUser!.uid)
                           
                            
                            FirebaseDataService.createUserData(userID!, bat: String(batteryLevel), username: username!, kaputSent: 0)
                            self.performSegue(withIdentifier: "toFriendList", sender: self)
                
                        }
                        
                    }

                }}
            
            }, withCancel: { error in
                
                print(error.localizedDescription)
                
        })
       
            } else {
                notification.notificationLabelBackgroundColor = KaputStyle.lowRed
                notification.displayNotificationWithMessage("DUDE! GET A CONNECTION!", forDuration: 3.0)
                
            }
            }
    
    
    
    
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
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
    func errorAlert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    //inutile
    func sccuessAlert(_ title: String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
       
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
