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




class SignInViewController: UIViewController {
    


    
    @IBOutlet weak var emailField: kaputField!
    @IBAction func resetPassword(sender: AnyObject) {
        
            let email = self.emailField.text
        if email?.characters.count<8 {
            self.errorAlert("Oops", message: "Please enter vaild email address!")
        }else{
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
        
        var email = self.emailField.text
        var password = self.passwordField.text
        email = email!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        password = password!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        if email!.characters.count<8{
            self.errorAlert("Oops!", message: "Please type valid email!")
        } else if password!.characters.count<8{
            self.errorAlert("Oops!", message: "Please type valid password!")
            
        } else{

            let spinner: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0,0,80,80)) as UIActivityIndicatorView
            self.view.addSubview(spinner)
            spinner.startAnimating()
            FIRAuth.auth()?.signInWithEmail(email!, password: password!){(user,error) in
                spinner.stopAnimating()
                if let error = error {
                    self.errorAlert("Opps!", message:"Wrong username or password")
                }else{
                    self.view.endEditing(true)

                    self.sccuessAlert("Success", message: "Welcome to Kaput")
                   // dispatch_async(dispatch_get_main_queue(),{()-> Void in
                        self.performSegueWithIdentifier("FriendList", sender: self)
                       // UIApplication.sharedApplication().keyWindow?.rootViewController = loginViewController
                    
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()


        
        
    emailField.becomeFirstResponder()
        view.backgroundColor = Colors.init().bgColor
        


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
