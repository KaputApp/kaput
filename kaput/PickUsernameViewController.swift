//
//  PickUsernameViewController.swift
//  
//
//  Created by Jeremy OUANOUNOU on 04/08/2016.
//
//

import UIKit

class PickUsernameViewController: UIViewController {

    @IBOutlet var usernameField: kaputField!
    
    @IBOutlet var almostLabel: SpringLabel!
    
    @IBOutlet var saveChangeButton: kaputPrimaryButton!
    @IBOutlet var avatarImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Colors.init().bgColor
        
        self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.size.width / 2;
        self.avatarImageView.layer.borderWidth = 5;
        self.avatarImageView.layer.borderColor = UIColor.whiteColor().CGColor;


    
    
    }
    @IBAction func saveChanges(sender: AnyObject) {
    
    Errors.clearErrors(usernameField)
    self.saveChangeButton.animation = "shake"

    let username: String = self.usernameField.text!
        
        var error = false
        
        if username == "" {
            Errors.errorMessage("REQUIRED",field: self.usernameField)
            error = true
            self.saveChangeButton.animate()
            
        }
        else if username.characters.count<5 {
            Errors.errorMessage("5 CHAR MIN",field: self.usernameField)
            error = true
            self.saveChangeButton.animate()

        }

        if !error{
        
            ref.child("Users").child(userID).updateChildValues(["name":username])
            self.performSegueWithIdentifier("toFriendList", sender: self)

            
        }
        
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
