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


class SignUpViewController: UIViewController {
    

    @IBOutlet weak var usernameField: kaputField!
    @IBOutlet weak var passwordField: kaputField!
    @IBOutlet weak var emailField: kaputField!
    @IBOutlet var signUpButton: kaputButton!
    @IBAction func signUpButton(sender: AnyObject) {
        
        
        

        let username: String? = self.usernameField.text
        let email = self.emailField.text
        let password = self.passwordField.text
        
        
        let err: PaddingLabel = PaddingLabel()
        
        
        err.opacity = 0
        err.backgroundColor = KaputStyle.midYellow
        err.textColor = UIColor.whiteColor()
        err.duration = 1
        err.font = UIFont(name: "Futura-Condensed", size: 18.0 )
        err.animation = "fadeInRight"
        let rect = err.frame
        let myLabelInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        err.drawTextInRect(UIEdgeInsetsInsetRect(rect, myLabelInsets))
    
        
        func errorMessage(text: String,field: kaputField){
        
        err.text = text
        err.frame =  CGRectMake(0,0,field.frame.width,field.frame.height)
        err.sizeToFit()
        err.frame =  CGRectMake(0,0,err.frame.width + 30,field.frame.height + 10)
        err.frame.origin.x = field.frame.width - err.frame.width
        field.addSubview(err)
        err.animate()
            
        }
        
        
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
        
        if username?.characters.count<5 {
            errorMessage("5 CHAR MIN",field: self.usernameField)
            
        } else if email?.characters.count<8 {
            errorMessage("INVALID MAIL",field: self.emailField)
        }else if password?.characters.count<8{
            errorMessage("INVALID PASSWORD",field: self.passwordField)
        }
        else {
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
    
}
    
    
    
   override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toFriendList" {
            print("prepareforsegue is called")

  
 


            
        }
    }
    
    
    override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = Colors.init().bgColor
        
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
    
    
    
    
    
    


}
