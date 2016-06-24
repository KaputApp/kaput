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
        //refresh textfiled - non utilisé
        
        
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
            
            signUpButton.titleLabel?.text = ""
            let spinner: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(self.view.frame.size.width/2-40,signUpButton.frame.origin.y,80,80))as UIActivityIndicatorView
            self.view.addSubview(spinner)
            spinner.startAnimating()
            
            FIRAuth.auth()?.createUserWithEmail(email!, password: password!){(user,error) in
                spinner.stopAnimating()
                if let error = error{
                    self.errorAlert("Opps!", message:"\(error.localizedDescription)")
                }else{
        

                    print("user created")
                    print(email!)
                    
                    self.performSegueWithIdentifier("toFriendList", sender: self)

                    
//                    dispatch_async(dispatch_get_main_queue(), {()-> Void in
//                        self.performSegueWithIdentifier("toFriendList", sender: self)
//                    })
                    
                    //dispatch_async(dispatch_get_main_queue(), {()-> Void in
//                        let loginViewController = self.storyboard!.instantiateViewControllerWithIdentifier("friendListView")
//                        UIApplication.sharedApplication().keyWindow?.rootViewController = loginViewController
                

                   // })

                }
                
            }
            
        }
    
}
    
    
   override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toFriendList" {
            print("prepareforsegue is called")

            
    let username = self.usernameField.text
            
            let userRef = ref.child("Users/yB439wHnQXhzjjYTRPyNT0uRrpG3/name")
            
            userRef.observeEventType(.Value, withBlock: { snapshot in
                
                if snapshot.exists() {
                    
                    print("snapshot exists")
                    
                } else {
                    
                    print("snapshot doesnt exist")
                    
                }
                
                
                userRef.removeAllObservers()
                
                }, withCancelBlock: { error in
                    
                    print(error)
                    
            })
    
            print(userID)
  
            FirebaseDataService.createUserData(userID, bat: String(batteryLevel), username: username!)
            
            // a supprimer
            
//            ref.child("Users").child(userID).setValue(["userID": userID, "batteryLevel": batteryLevel, "isOnLine": "true", "name":String(username!)])
//        
            
            let toView = segue.destinationViewController as! FriendListViewController

            // ce  bout de cote doit aller dans la friendList!
            
            
//            FirebaseDataService.getFriendList("xy2olnrUo2Wa5FY59c6KXIY4on62",response: { (friendList) -> () in
//                
//                if friendList.allKeys.isEmpty == true {
//                    toView.data = ["Sans Ami"]
//                    toView.friendsTableView.reloadData()
//                }
//                else {
//                    print("ya des gens")
//                toView.data =  friendList.allKeys as! [String]
//                toView.friendsTableView.reloadData()
//
//
//                }
//                
//            })
//            
            
            
            //jusqu'ici
            
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
