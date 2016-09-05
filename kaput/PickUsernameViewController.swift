//
//  PickUsernameViewController.swift
//  
//
//  Created by OPE50 Team on 04/08/2016.
//
//

import UIKit
import FBSDKLoginKit
import Firebase
import FirebaseAuth

class PickUsernameViewController: UIViewController {

    @IBAction func logOut(sender: AnyObject) {
        
        let optionMenu = UIAlertController(title: nil, message: "Are you sure ?", preferredStyle: .ActionSheet)
        
        let logOutAction = UIAlertAction(title: "Log Out", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            try! FIRAuth.auth()!.signOut()
            let loginManager = FBSDKLoginManager()
            loginManager.logOut()
            
            
            self.performSegueWithIdentifier("logoutSegue", sender: self)
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            
        })
        
        optionMenu.addAction(logOutAction)
        optionMenu.addAction(cancelAction)
        
        
        self.presentViewController(optionMenu, animated: true, completion: nil)
        
    
    }
    @IBOutlet var usernameField: kaputField!
    
    @IBOutlet var almostLabel: SpringLabel!
    
    @IBOutlet var saveChangeButton: kaputPrimaryButton!
    @IBOutlet var avatarImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        FirebaseDataService.getAvatarFromFirebase({(image) in
            myAvatar = image
            self.avatarImageView.image = myAvatar
            

        })
        
        self.avatarImageView.clipsToBounds = true
        self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.size.width / 2;
        self.avatarImageView.layer.borderWidth = 5;
        self.avatarImageView.layer.borderColor = UIColor.whiteColor().CGColor;
        
        view.backgroundColor = Colors.init().bgColor
        
       
    
    }
    
    
    @IBAction func saveChanges(sender: AnyObject) {
    
    Errors.clearErrors(usernameField)
    self.saveChangeButton.animation = "shake"

    let username: String = self.usernameField.text!
        
        var error = false
        
        ref.child("Users").queryOrderedByChild("name").queryEqualToValue(username).observeEventType(.Value, withBlock: { snapshot in
            if snapshot.exists() == true {
                
                Errors.errorMessage("ALREADY TAKEN",field: self.usernameField)
                
            } else
        
        if username == "" {
            Errors.errorMessage("REQUIRED",field: self.usernameField)
            error = true
            self.saveChangeButton.animate()
            
        }
        else if username.characters.count<4 {
            Errors.errorMessage("4 CHAR MIN",field: self.usernameField)
            error = true
            self.saveChangeButton.animate()

        }
           else if username.rangeOfCharacterFromSet(letters.invertedSet) != nil {
                Errors.errorMessage("ONLY ALPHA NUMERIC",field: self.usernameField)
                error = true
            }

        if !error{
        
            ref.child("Users").child(userID).updateChildValues(["name":username])
            self.performSegueWithIdentifier("toFriendList", sender: self)

            
            }
            }, withCancelBlock: { error in
                
                print(error.localizedDescription)
                
            })

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
