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
    var notifCounter = 1
    var kaputCounter = 1


    let userID = FIRAuth.auth()?.currentUser?.uid
 
    
    @IBOutlet var numberLeft: SpringLabel!
    @IBOutlet var timeLabel: UILabel!
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
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animator = UIDynamicAnimator(referenceView: view)
        notifView.alpha = 0
     


        
         }
    
    

    
        func loadDatafromFirebase(){
            
           
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            
            var kaputs =  ref.child("Users").child(userID!).child("kaput").observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
                
                self.kaputCounter = Int(snapshot.childrenCount)
            }) { (error) in
                print(error.localizedDescription)
            }

            
            
            var notifKaput = ref.child("Users").child(userID!).child("kaput").child(String(notifCounter)).observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
            
                let postDict = snapshot.value as! [String : AnyObject]
                
                print(postDict)
                
                
                let senderText =  snapshot.value?["sent_by"] as? String
                let timeText = snapshot.value?["sent_date"] as? String
                let levelBat = snapshot.value?["levelBattery"] as? String
                
                
                self.senderLabel.text = "\(senderText!) IS \(levelBat!)%"
                self.timeLabel.text = timeText
                
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
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

        self.numberLeft.text = String(1 + kaputCounter - notifCounter)

        
        
    }


   
    func refreshView() {
        

        notifCounter=notifCounter+1
        
        if notifCounter > kaputCounter {
            notifCounter = 1
        }
        
        self.numberLeft.text = String(1 + kaputCounter - notifCounter)
        
        animator.removeAllBehaviors()
        snapBehavior = UISnapBehavior(item: notifView, snapToPoint: view.center)
        attachmentBehavior.anchorPoint = view.center
        notifView.center = view.center

        viewDidAppear(true)
    }
    
    
    
}
