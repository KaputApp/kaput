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



class ProfileViewController: UIViewController, FBSDKAppInviteDialogDelegate, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate, UIScrollViewDelegate {
 
    

    @IBOutlet var backButton: downButton!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var boltImageView: UIImageView!
    @IBOutlet var myNameLabel: SpringLabel!
    @IBOutlet var kaputSent: SpringLabel!
    @IBOutlet var myBatteryLevel: UILabel!

    @IBAction func sendFeedback(_ sender: AnyObject) {
        

            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["jeremouans@gmail.com"])
            mail.setSubject("Kaput Feedback")
            
            present(mail, animated: true, completion: nil)
  
        }
    
    
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    


    @IBAction func inviteFriend(_ sender: AnyObject) {

        
        if reachable == true {
            

            let optionMenu = UIAlertController(title: nil, message: "INVITE FRIENDS", preferredStyle: .actionSheet)
            
            let smsAction = UIAlertAction(title: "SMS", style: .default, handler: {
                (alert: UIAlertAction!) -> Void in
             
                let messageVC = MFMessageComposeViewController()
                
                messageVC.body = "Hey, I have \(batteryLevel)% of battery, what about you?"
                messageVC.messageComposeDelegate = self
         

                self.present(messageVC, animated: true, completion: nil)
                
            })
            let whatsappAction = UIAlertAction(title: "WHATSAPP", style: .default, handler: {
                (alert: UIAlertAction!) -> Void in
                
                let urlString = "Hey, I have \(batteryLevel)% of battery, what about you?"
                let urlStringEncoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
                let url  = URL(string: "whatsapp://send?text=\(urlStringEncoded!)")
                if UIApplication.shared.canOpenURL(url!) {
                    UIApplication.shared.openURL(url!)
                }

                
            })
            
            let facebookAction = UIAlertAction(title: "FACEBOOK", style: .default, handler: {
                (alert: UIAlertAction!) -> Void in
                
                let content: FBSDKAppInviteContent = FBSDKAppInviteContent()
                content.appLinkURL = URL(string: "https://fb.me/1243777468988577")!
                //optionally set previewImageURL
                content.appInvitePreviewImageURL = URL(string: "https://lh4.googleusercontent.com/4mKKCWymaRzOW6TNwipzXWokqcVpmDTMtJ3tUSaCCIffVkmceJy5Qk5Usd246ePoiSC9sMhmXug2wO4=w1280-h701-rw")
                // Present the dialog. Assumes self is a view controller
                // which implements the protocol `FBSDKAppInviteDialogDelegate`.
                FBSDKAppInviteDialog.show(from: self, with: content, delegate: self)
            })
            
            //
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
                (alert: UIAlertAction!) -> Void in
                
            })
            
            
            optionMenu.addAction(smsAction)
            optionMenu.addAction(whatsappAction)
            optionMenu.addAction(facebookAction)
            optionMenu.addAction(cancelAction)
            
            
            self.present(optionMenu, animated: true, completion: nil)
            
        } else {
            notification.notificationLabelBackgroundColor = KaputStyle.lowRed
            notification.displayNotificationWithMessage("DUDE! GET A CONNECTION!", forDuration: 3.0)
        }
    

    }
    
    func appInviteDialog(_ appInviteDialog: FBSDKAppInviteDialog!, didCompleteWithResults results: [AnyHashable: Any]!) {
        //TODO
    }
    func appInviteDialog(_ appInviteDialog: FBSDKAppInviteDialog!, didFailWithError error: Error!) {
        //TODO
    }

    
    @IBAction func LogOut(_ sender: AnyObject) {
    
        let optionMenu = UIAlertController(title: nil, message: "Are you sure ?", preferredStyle: .actionSheet)
        
        let logOutAction = UIAlertAction(title: "Log Out", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            try! FIRAuth.auth()!.signOut()
            let loginManager = FBSDKLoginManager()
            loginManager.logOut()
            
          
            self.performSegue(withIdentifier: "logoutSegue", sender: self)

        })

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            
        })

        optionMenu.addAction(logOutAction)
        optionMenu.addAction(cancelAction)
        
        
        self.present(optionMenu, animated: true, completion: nil)
        
    }


    @IBOutlet var avatarImageView: UIImageView!

    override func viewDidLoad() {

        
        ref.child("Users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let snapshotValue = snapshot.value as? NSDictionary , let kaputSentView  = snapshotValue["kaputSent"] as? Int {
            self.kaputSent.text = String(kaputSentView)
           
            } else {
            self.kaputSent.text = ""
            }
            })

        
        super.viewDidLoad()
        

        boltImageView.image = KaputStyle.imageOfBolt
        scrollView.delegate = self

        view.backgroundColor = Colors.init().bgColor
        self.myNameLabel.text = myUsername
        self.avatarImageView.image = myAvatar
        self.avatarImageView.contentMode = .scaleAspectFill
        self.avatarImageView.clipsToBounds = true
        self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.size.width / 2;
        self.avatarImageView.layer.borderWidth = 5;
        self.avatarImageView.layer.borderColor = UIColor.white.cgColor;
        
        self.myBatteryLevel.text = String(batteryLevel) + " %"
        
        //self.kaputSent.text = "3"

        batLenght = CGFloat(batteryLevel)
    }


        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.contentOffset.y <= 0 {
        self.backButton.transform = CGAffineTransform.identity
        }


        if scrollView.contentOffset.y <= 60 && scrollView.contentOffset.y > 0 {
        
        self.backButton.transform = CGAffineTransform.identity
        let angle = CGFloat(M_PI)*scrollView.contentOffset.y/60
        self.backButton.transform = self.backButton.transform.rotated(by: angle)
       

        }
        
        if scrollView.contentOffset.y > 60 {
            self.backButton.transform = CGAffineTransform.identity
            self.backButton.transform = self.backButton.transform.rotated(by: CGFloat(M_PI))
        }
        
        if scrollView.contentOffset.y > 80 {
            self.scrollView.isScrollEnabled = false
            self.performSegue(withIdentifier: "downToFriendList", sender: self)

        }
    }

    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult){
        
        
        
        self.dismiss(animated: true) { () -> Void in
            
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
