//
//  ProfileViewController.swift
//  kaput
//
//  Created by OPE50 Team on 15/07/2016.
//  Copyright © 2016 OPE50. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FBSDKLoginKit
import FBSDKCoreKit
import FBSDKShareKit
import MessageUI
import FirebaseInstanceID





class ProfileViewController: UIViewController, FBSDKAppInviteDialogDelegate, MFMessageComposeViewControllerDelegate, UIScrollViewDelegate {
 
    

    @IBOutlet var backButton: downButton!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var boltImageView: UIImageView!
    @IBOutlet var myNameLabel: SpringLabel!
    @IBOutlet var kaputSent: SpringLabel!
    @IBOutlet var myBatteryLevel: UILabel!

    
    @IBAction func inviteFriend(sender: AnyObject) {
        
        
        if reachable == true {

            
            
            let optionMenu = UIAlertController(title: nil, message: "INVITE FRIENDS", preferredStyle: .ActionSheet)
            
            // 2
            let smsAction = UIAlertAction(title: "SMS", style: .Default, handler: {
                (alert: UIAlertAction!) -> Void in
              //  UIApplication.sharedApplication().openURL(NSURL(string: "sms:")!)
                let messageVC = MFMessageComposeViewController()
                
                messageVC.body = "Hey, I have \(batteryLevel)% of battery, what about you?"
                messageVC.messageComposeDelegate = self
         
                
                
                self.presentViewController(messageVC, animated: true, completion: nil)
                
            })
            let whatsappAction = UIAlertAction(title: "WHATSAPP", style: .Default, handler: {
                (alert: UIAlertAction!) -> Void in
                
                var urlString = "Hey, I have \(batteryLevel)% of battery, what about you?"
                var urlStringEncoded = urlString.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
                var url  = NSURL(string: "whatsapp://send?text=\(urlStringEncoded!)")
                if UIApplication.sharedApplication().canOpenURL(url!) {
                    UIApplication.sharedApplication().openURL(url!)
                }

                
            })
            
            let facebookAction = UIAlertAction(title: "FACEBOOK", style: .Default, handler: {
                (alert: UIAlertAction!) -> Void in
                
                let content: FBSDKAppInviteContent = FBSDKAppInviteContent()
                content.appLinkURL = NSURL(string: "https://fb.me/1243777468988577")!
                //optionally set previewImageURL
                content.appInvitePreviewImageURL = NSURL(string: "https://lh4.googleusercontent.com/4mKKCWymaRzOW6TNwipzXWokqcVpmDTMtJ3tUSaCCIffVkmceJy5Qk5Usd246ePoiSC9sMhmXug2wO4=w1280-h701-rw")
                // Present the dialog. Assumes self is a view controller
                // which implements the protocol `FBSDKAppInviteDialogDelegate`.
                FBSDKAppInviteDialog.showFromViewController(self, withContent: content, delegate: self)
            })
            
            //
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
                (alert: UIAlertAction!) -> Void in
                
            })
            
            
            optionMenu.addAction(smsAction)
            optionMenu.addAction(whatsappAction)
            optionMenu.addAction(facebookAction)
            optionMenu.addAction(cancelAction)
            
            
            self.presentViewController(optionMenu, animated: true, completion: nil)
            
        } else {
            notification.notificationLabelBackgroundColor = KaputStyle.lowRed
            notification.displayNotificationWithMessage("DUDE! GET A CONNECTION!", forDuration: 3.0)
        }
    

    }
    
    func appInviteDialog(appInviteDialog: FBSDKAppInviteDialog!, didCompleteWithResults results: [NSObject : AnyObject]!) {
        //TODO
    }
    func appInviteDialog(appInviteDialog: FBSDKAppInviteDialog!, didFailWithError error: NSError!) {
        //TODO
    }

    
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

        
        ref.child("Users").child(userID).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            let kaputSentView = snapshot.value!["kaputSent"] as! Int
            self.kaputSent.text = String(kaputSentView)
           
            }
            )
        

        
        super.viewDidLoad()
        

        
        boltImageView.image = KaputStyle.imageOfBolt
        scrollView.delegate = self

        view.backgroundColor = Colors.init().bgColor
        self.myNameLabel.text = myUsername
        self.avatarImageView.image = myAvatar
        self.avatarImageView.contentMode = .ScaleAspectFill
        self.avatarImageView.clipsToBounds = true
        self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.size.width / 2;
        self.avatarImageView.layer.borderWidth = 5;
        self.avatarImageView.layer.borderColor = UIColor.whiteColor().CGColor;
        
        self.myBatteryLevel.text = String(batteryLevel) + " %"
        
        //self.kaputSent.text = "3"

        batLenght = CGFloat(batteryLevel)
    }


        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if scrollView.contentOffset.y <= 0 {
        self.backButton.transform = CGAffineTransformIdentity
        }


        if scrollView.contentOffset.y <= 60 && scrollView.contentOffset.y > 0 {
        
        self.backButton.transform = CGAffineTransformIdentity
        let angle = CGFloat(M_PI)*scrollView.contentOffset.y/60
        self.backButton.transform = CGAffineTransformRotate(self.backButton.transform, angle)
       

        }
        
        if scrollView.contentOffset.y > 60 {
            self.backButton.transform = CGAffineTransformIdentity
            self.backButton.transform = CGAffineTransformRotate(self.backButton.transform, CGFloat(M_PI))
        }
        
        if scrollView.contentOffset.y > 80 {
            self.scrollView.scrollEnabled = false
            self.performSegueWithIdentifier("downToFriendList", sender: self)

        }
    }
    

    
    func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult result: MessageComposeResult){
        
        switch (result) {
            
        case MessageComposeResultCancelled:
            break
            
        case MessageComposeResultFailed:
            
            break
            
        case MessageComposeResultSent:
            
            break
            
        default:
            break
        }
        
        self.dismissViewControllerAnimated(true) { () -> Void in
            
        }
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
