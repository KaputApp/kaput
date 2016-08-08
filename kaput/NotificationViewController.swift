//
//  NotificationViewController.swift
//  kaput
//
//  Created by Jeremy OUANOUNOU on 09/06/2016.
//  Copyright © 2016 OPE50. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseDatabase


@IBDesignable



class NotificationViewController: UIViewController {

    var animator : UIDynamicAnimator!
    var attachmentBehavior : UIAttachmentBehavior!
    var gravityBehaviour : UIGravityBehavior!
    var snapBehavior : UISnapBehavior!
//    var notifCounter = 1
    var kaputCounter = 1
    var senderText = String()


    let userID = FIRAuth.auth()?.currentUser?.uid
 
    
    @IBOutlet var numberLeft: SpringLabel!
    @IBOutlet var timeLabel: PaddingLabel!
    @IBOutlet var senderLabel: UILabel!
    @IBOutlet var notifView: BigNotifView!
    @IBOutlet var PanRecognizer: UIPanGestureRecognizer!
    
    @IBOutlet var notifTapRecognizer: UITapGestureRecognizer!
    @IBAction func HangGesture(sender: AnyObject) {
    
    let myView = notifView
    let location = sender.locationInView(view)
    let boxLocation = sender.locationInView(notifView)
        
    if sender.state == UIGestureRecognizerState.Began {
        if snapBehavior != nil
        {
                animator.removeBehavior(snapBehavior)
        }
            
            let centerOffset = UIOffsetMake(boxLocation.x - CGRectGetMidX(myView.bounds), boxLocation.y - CGRectGetMidY(myView.bounds));
            attachmentBehavior = UIAttachmentBehavior(item: myView, offsetFromCenter: centerOffset, attachedToAnchor: location)
            attachmentBehavior.frequency = 0
            
            animator.addBehavior(attachmentBehavior)
        }
        else if sender.state == UIGestureRecognizerState.Changed {
            attachmentBehavior.anchorPoint = location
        }
        else if sender.state == UIGestureRecognizerState.Ended {
            animator.removeBehavior(attachmentBehavior)
            
            snapBehavior = UISnapBehavior(item: myView, snapToPoint: view.center)
            animator.addBehavior(snapBehavior)
            
            let translation = sender.translationInView(view)

        
        
        if translation.x > 100 {
            
            animator.removeAllBehaviors()
                
            let gravity = UIGravityBehavior(items: [notifView])
            gravity.gravityDirection = CGVectorMake(10, 0)
            animator.addBehavior(gravity)
            
            self.numberLeft.alpha = 0

            delay(0.3) {
                self.refreshView()
            }
            
                
            }
        }
    }
    
    @IBAction func shake(sender: AnyObject) {
      
        notifView.animation = "swing"
        notifView.animate()
        FirebaseDataService.sendMessageToName(self.senderText)

        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animator = UIDynamicAnimator(referenceView: view)
        notifView.alpha = 0
     

        
         }
    
    

     func loadDatafromFirebase(){
            
           
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            
            ref.child("Users").child(userID!).child("kaput").queryOrderedByChild("read").queryEqualToValue(false).observeSingleEventOfType(FIRDataEventType.Value, withBlock: { (snapshot) in
                
                self.kaputCounter = Int(snapshot.childrenCount)

                self.numberLeft.text = String(self.kaputCounter)
                
               
                
                
            }) { (error) in
                print(error.localizedDescription)
            }
        

            ref.child("Users").child(userID!).child("kaput").queryOrderedByChild("read").queryEqualToValue(false).queryLimitedToFirst(1).observeSingleEventOfType(FIRDataEventType.Value, withBlock: { (snapshot) in
            
                let keyDict = snapshot.value as! [String : AnyObject]
                print("lol")
                let key = keyDict.keys.first!
                print(key)
                ref.child("Users").child(self.userID!).child("kaput").child(key).updateChildValues(["read":true])
              
                UIApplication.sharedApplication().applicationIconBadgeNumber = self.kaputCounter

                for child in snapshot.children{
                    
            
                self.senderText =  child.value?["sent_by"] as! String
                let timeText = child.value?["sent_date"] as? String
                let levelBat = child.value?["levelBattery"] as? String
                
                    
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
                    let sentDate = dateFormatter.dateFromString(timeText!)
                    print("dateText \(sentDate!)")
                    
                let interval = NSDate().timeIntervalSinceDate(sentDate!)
                    
                let dateComponentsFormatter = NSDateComponentsFormatter()
                    dateComponentsFormatter.unitsStyle = NSDateComponentsFormatterUnitsStyle.Short
                let intervalAgo = dateComponentsFormatter.stringFromTimeInterval(interval)
                let timeAgo = "\(intervalAgo!.uppercaseString) AGO"
                self.senderLabel.text = "\(self.senderText) IS \(levelBat!)%"
                self.timeLabel.backgroundColor = KaputStyle.chargingBlue
                self.timeLabel.text = timeAgo
                notifLenght = Int(levelBat!)!
                print("this is \(notifLenght)")
                self.notifView.setNeedsDisplay()
                }
            }) { (error) in
    print(error.localizedDescription)
    }

}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(animated: Bool) {
       
    }
    
    override func viewDidAppear(animated: Bool) {
        

    notifView.animation = "zoomIn"
    notifView.delay = 0.2
    notifView.animate()
    
    notifView.alpha = 1
    self.numberLeft.alpha = 1
    numberLeft.animation = "zoomIn"
    numberLeft.animate()
    
    loadDatafromFirebase()
        
        
    }


   
    func refreshView() {
        

        
        
        if kaputCounter == 1 {
            
        self.performSegueWithIdentifier("unWindtoFriendList", sender: self)
        } else {
        
        self.numberLeft.text = String(self.kaputCounter)
            
        animator.removeAllBehaviors()
        snapBehavior = UISnapBehavior(item: notifView, snapToPoint: view.center)
        attachmentBehavior.anchorPoint = view.center
        notifView.center = view.center
        viewDidAppear(true)


        }
        
        }
    
    
    
}
