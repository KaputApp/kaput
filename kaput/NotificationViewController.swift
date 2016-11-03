//
//  NotificationViewController.swift
//  kaput
//
//  Created by OPE50 Team on 09/06/2016.
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
    @IBAction func HangGesture(_ sender: AnyObject) {
    
    let myView = notifView
    let location = sender.location(in: view)
    let boxLocation = sender.location(in: notifView)
        
    if sender.state == UIGestureRecognizerState.began {
        if snapBehavior != nil
        {
                animator.removeBehavior(snapBehavior)
        }
            
            let centerOffset = UIOffsetMake(boxLocation.x - (myView?.bounds.midX)!, boxLocation.y - (myView?.bounds.midY)!);
            attachmentBehavior = UIAttachmentBehavior(item: myView!, offsetFromCenter: centerOffset, attachedToAnchor: location)
            attachmentBehavior.frequency = 0
            
            animator.addBehavior(attachmentBehavior)
        }
        else if sender.state == UIGestureRecognizerState.changed {
            attachmentBehavior.anchorPoint = location
        }
        else if sender.state == UIGestureRecognizerState.ended {
            animator.removeBehavior(attachmentBehavior)
            
            snapBehavior = UISnapBehavior(item: myView!, snapTo: view.center)
            animator.addBehavior(snapBehavior)
            
            let translation = sender.translation(in: view)

        
        
        if translation.x > 100 {
            
            animator.removeAllBehaviors()
                
            let gravity = UIGravityBehavior(items: [notifView])
            gravity.gravityDirection = CGVector(dx: 10, dy: 0)
            animator.addBehavior(gravity)
            
            self.numberLeft.alpha = 0

            delay(delay: 0.3) {
                self.refreshView()
            }
            
                
            }
        }
    }
    
    @IBAction func shake(_ sender: AnyObject) {
      
        notifView.animation = "swing"
        notifView.animate()
        FirebaseDataService.sendMessageToName(self.senderText)
        
        print(self.senderText)

        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animator = UIDynamicAnimator(referenceView: view)
        notifView.alpha = 0
     

        
         }
    
    

     func loadDatafromFirebase(){
            
           
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            
            ref.child("Users").child(userID!).child("kaput").queryOrdered(byChild: "read").queryEqual(toValue: false).observeSingleEvent(of: FIRDataEventType.value, with: { (snapshot) in
                
                self.kaputCounter = Int(snapshot.childrenCount)

                self.numberLeft.text = String(self.kaputCounter)
                
               
                
                
            }) { (error) in
                print(error.localizedDescription)
            }
        

            ref.child("Users").child(userID!).child("kaput").queryOrdered(byChild: "read").queryEqual(toValue: false).observeSingleEvent(of: FIRDataEventType.value, with: { (snapshot) in
                
                print(snapshot)
                
                
                    
                let keyDict = snapshot.value as! [String : AnyObject]
                let key = keyDict.keys.first!
            ref.child("Users").child(self.userID!).child("kaput").child(key).updateChildValues(["read":true])
                
                
                
                UIApplication.shared.applicationIconBadgeNumber = self.kaputCounter

                for child in snapshot.children{
                    
            
                    self.senderText = (child as? NSDictionary)?["sent_by"] as! String
                if  let timeText = (child as? NSDictionary)?["sent_date"] as? String
                , let levelBat = (child as? NSDictionary)?["levelBattery"] as? String {
                
                
                
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
                    let sentDate = dateFormatter.date(from: timeText)
                    print("dateText \(sentDate!)")
                    
                let interval = Date().timeIntervalSince(sentDate!)
                let dateComponentsFormatter = DateComponentsFormatter()
                    dateComponentsFormatter.unitsStyle = DateComponentsFormatter.UnitsStyle.short
                let intervalAgo = dateComponentsFormatter.string(from: interval)
                let timeAgo = "\(intervalAgo!.uppercased()) AGO"
                self.senderLabel.text = "\(self.senderText) IS \(levelBat)%"
                self.timeLabel.backgroundColor = KaputStyle.chargingBlue
                self.timeLabel.text = timeAgo
                notifLenght = Int(levelBat)!
                print("this is \(notifLenght)")
                self.notifView.setNeedsDisplay()
           
              }else{
                    }
                }
            }) { (error) in
    print(error.localizedDescription)
    }

}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        

    notifView.animation = "zoomIn"
    notifView.delay = 0.2
    notifView.animate()
    
    notifView.alpha = 1
    self.numberLeft.alpha = 1
    numberLeft.animation = "zoomIn"
    numberLeft.animate()
    
    loadDatafromFirebase()
        
        
    }

    @IBAction func dismissAll(_ sender: AnyObject) {
        
          ref.child("Users").child(userID!).child("kaput").queryOrdered(byChild: "read").queryEqual(toValue: false).observeSingleEvent(of: FIRDataEventType.value, with: { (snapshot) in
            if snapshot.exists() {
            let keyDict = snapshot.value as! [String : AnyObject]
            for key in keyDict.keys {
            ref.child("Users").child(self.userID!).child("kaput").child(key).updateChildValues(["read":true])
                }
            
            }
          
            self.performSegue(withIdentifier: "unWindtoFriendList", sender: self)

          
          })
        
    }
   
    func refreshView() {

        if kaputCounter == 1 {
            
        self.performSegue(withIdentifier: "unWindtoFriendList", sender: self)
        } else {
        
        self.numberLeft.text = String(self.kaputCounter)
            
        animator.removeAllBehaviors()
        snapBehavior = UISnapBehavior(item: notifView, snapTo: view.center)
        attachmentBehavior.anchorPoint = view.center
        notifView.center = view.center
        viewDidAppear(true)


        }
        
        }
    
    
    
}
