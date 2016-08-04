//
//  ProfileViewController.swift
//  kaput
//
//  Created by Jeremy OUANOUNOU on 15/07/2016.
//  Copyright © 2016 OPE50. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage

class ProfileViewController: UIViewController {

    @IBAction func LogOut(sender: AnyObject) {
        
        try! FIRAuth.auth()!.signOut()
        performSegueWithIdentifier("logoutSegue", sender: self)
        
    }
    @IBOutlet var avatarImageView: UIImageView!
    override func viewDidLoad() {
        let storage = FIRStorage.storage()
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let storageRef = storage.referenceForURL("gs://project-3561187186486872408.appspot.com/")
        let avatar = storageRef.child("Image/\(userID)/avatar.jpg")
        let documentsDirectory = paths[0]
        let filePath = "Image/\(FIRAuth.auth()!.currentUser!.uid)/avatar.jpg"
        let storagePath = NSUserDefaults.standardUserDefaults().objectForKey("storagePath") as! String
    
        print("lololol")
        
        print(storageRef)
        print(filePath)
        print(storagePath)
        

        // [END downloadimage]
        
        super.viewDidLoad()
        
        view.backgroundColor = Colors.init().bgColor
        
        self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.size.width / 2;
        self.avatarImageView.layer.borderWidth = 5;
        self.avatarImageView.layer.borderColor = UIColor.whiteColor().CGColor;
        
        storageRef.child(storagePath).writeToFile(NSURL.init(string: filePath)!,
                                                  completion: { (url, error) in
        if let error = error {
            print("Error downloading:\(error)")
            print("Download Failed")
            return
        }
        print("Download Succeeded!")
        self.avatarImageView.image = UIImage.init(contentsOfFile: filePath)
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
