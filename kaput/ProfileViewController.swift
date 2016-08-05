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
import FBSDKLoginKit

class ProfileViewController: UIViewController {

    
    @IBOutlet var boltImageView: UIImageView!
    @IBOutlet var kaputSent: SpringLabel!
    
    @IBAction func LogOut(sender: AnyObject) {
    
        let optionMenu = UIAlertController(title: nil, message: "Are you sure ?", preferredStyle: .ActionSheet)
        
        let cameraAction = UIAlertAction(title: "Log Out", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            try! FIRAuth.auth()!.signOut()
            self.performSegueWithIdentifier("logoutSegue", sender: self)

        })

        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            
        })

        optionMenu.addAction(cameraAction)
        optionMenu.addAction(cancelAction)
        
        
        self.presentViewController(optionMenu, animated: true, completion: nil)
        
    }



    @IBOutlet var avatarImageView: UIImageView!
    override func viewDidLoad() {
        

        super.viewDidLoad()
        
        boltImageView.image = KaputStyle.imageOfBolt

        
        
        let params: [NSObject : AnyObject] = ["redirect": false, "height": 800, "width": 800, "type": "large"]
        let storage = FIRStorage.storage()
        let storageRef = storage.referenceForURL("gs://project-3561187186486872408.appspot.com/")
        let avatar = storageRef.child("Image/\(userID)/avatar.jpg")
        let filePath = "Image/\(userID)/avatar.jpg"
        
        
        
        let pictureRequest = FBSDKGraphRequest(graphPath: "me/picture", parameters: params, HTTPMethod: "GET")
        
        pictureRequest.startWithCompletionHandler({
            (connection, result, error: NSError!) -> Void in
            if error == nil {
                print("\(result)")
                let dictionary = result as? NSDictionary
                let data = dictionary?.objectForKey("data")
                let urlPic = (data?.objectForKey("url"))! as! String
                print(urlPic)
                self.avatarImageView.image = imageFromURL(urlPic)
            }else{
                print("\(error)")
            }
       
        })

    
//        avatar.dataWithMaxSize(1 * 1024 * 1024) { (data, error) -> Void in
//            if (error != nil) {
//                print(error)
//            } else {
//                self.avatarImageView.image = UIImage(data: data!)
//            }
//        }
//    
    
        view.backgroundColor = Colors.init().bgColor
        
        self.avatarImageView.contentMode = .ScaleAspectFill

        
        self.avatarImageView.clipsToBounds = true
        self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.size.width / 2;
        self.avatarImageView.layer.borderWidth = 5;
        self.avatarImageView.layer.borderColor = UIColor.whiteColor().CGColor;
        
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
