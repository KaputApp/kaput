//
//  FriendListViewController.swift
//  kaput
//
//  Created by OPE50 Team on 09/06/2016.
//  Copyright © 2016 OPE50. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseDatabase
import MGSwipeTableCell

var myUsername = String()
var myAvatar = UIImage()


class FriendListViewController: UIappViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var friendsTableView: UITableView!
    @IBOutlet var kaputCounter: numberOfNotifications!
    var data = NSMutableArray()
    var kaputCount = Int()
    var friendShown = [Bool]()
    var refreshControl: UIRefreshControl!
    var boltView : UIView!
    var boltImageView : UIImageView!


override func viewDidLoad() {
    super.viewDidLoad()
    
    print("INITIALISATION")
    print(myAvatar)
    print(myUsername)
    print("END INIT")
    
    //charge les differents éléments

    print(userID)
    print(ref)
    
    
    
    FirebaseDataService.getName({(name) in
        myUsername = name
    })
    

    FirebaseDataService.getAvatarFromFirebase({(image) in
        myAvatar = image
    })

    ref.child("Users").child(userID!).updateChildValues(["batteryLevel": batteryLevel])

    FirebaseDataService.getFriendList(userID!,response: { (friendList) -> () in
        
        self.data =  friendList.allKeys  as! NSMutableArray
        
        self.friendShown = [Bool](repeating: false, count: self.data.count)
        
        self.friendsTableView.reloadData()


    })

    FirebaseDataService.getKaputList(userID!,response: { (kaputCount) -> () in
        self.kaputCount = Int(kaputCount)
        UIApplication.shared.applicationIconBadgeNumber = self.kaputCount

        if self.kaputCount != 0 {
            self.kaputCounter.isHidden = false
            self.kaputCounter.animation = "slideRight"
            self.kaputCounter.animate()
        } else {
            self.kaputCounter.isHidden = true
        }
            self.kaputCounter.setTitle(String(self.kaputCount),for: UIControlState())
        })
    
        self.setBoltView()
    
        friendsTableView.delegate = self
        friendsTableView.dataSource = self
        friendsTableView.backgroundColor = Colors.init().bgColor
    

}

override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
}
    
    
     func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return data.count
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath)  as! MGSwipeTableCell
        if hasFriend {
            cell.rightButtons = [MGSwipeButton(title: "", icon: KaputStyle.imageOfTrashCan,backgroundColor: KaputStyle.lowRed,padding:30,callback: {
            (sender: MGSwipeTableCell!) -> Bool in

            let name = tableView.cellForRow(at: indexPath)?.textLabel?.text
            FirebaseDataService.removeFriend(name!)
                FirebaseDataService.getUidWithUsername(name!,response: {(uid,exists)->() in
//                    let myName = [myUsername:true] as [String:Bool]
                   
                    ref.child("Users").child(uid).child("friends").child(myUsername).removeValue()
                })
            return true
       
        })]
        } else {
            cell.rightButtons = []        }
        cell.rightSwipeSettings.transition = MGSwipeTransition.drag
        
        cell.backgroundColor = Colors.init().bgColor


        cell.textLabel?.text = data[(indexPath as NSIndexPath).row] as! String
        
        let username = cell.textLabel!.text
        
        
        if hasFriend {
        FirebaseDataService.getBatLevelWithName(username!) { (batLevel) in
            
            cell.backgroundColor = ColorsForBat(batLevel)
            
        }
        }
        
        
        return cell
    }
    

    //ANIMATION CELL UP
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        if self.friendShown[(indexPath as NSIndexPath).row] == false
        {
            let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, 0, UIScreen.main.bounds.height - 40*CGFloat((indexPath as NSIndexPath).row - 1), 0)
            cell.layer.transform = rotationTransform
            
            SpringAnimation.spring(duration: 1.5)
            {
            cell.layer.transform = CATransform3DIdentity
            }
            friendShown[(indexPath as NSIndexPath).row] = true
        }
    }
    
    // BOLT VIEW
    
    func setBoltView() {
        
        
        self.refreshControl = UIRefreshControl()
        self.friendsTableView.addSubview(self.refreshControl)
        self.refreshControl?.addTarget(self, action: #selector(FriendListViewController.refresh), for: UIControlEvents.valueChanged)
       
        self.boltView = UIView(frame: self.refreshControl!.bounds)
        self.boltImageView = UIImageView(image: KaputStyle.imageOfBolt)
        self.boltView.addSubview(self.boltImageView)
        
        // Clip so the graphics don't stick out
        self.boltView.clipsToBounds = true;
        
        // center the image
        self.boltImageView.center = self.boltView.center
        
        

        
        // Hide the original spinner icon
        self.refreshControl!.tintColor = UIColor.clear
        
        // Add the loading and colors views to our refresh control
        self.refreshControl!.addSubview(self.boltView)

    }
    
    func refresh(){

        performSegue(withIdentifier: "profileSegue", sender: self)
        self.refreshControl!.endRefreshing()

    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
     
        // Get the current size of the refresh controller
        var refreshBounds = self.refreshControl!.bounds;
        
        // Distance the table has been pulled >= 0
        let pullDistance = max(0.0, -self.refreshControl!.frame.origin.y);
        
        // putting the bolt in the center of the refresh control view
        
        let boltHeight = self.boltImageView.bounds.size.height
        var boltWidth = self.boltImageView.bounds.size.width
        let boltY = pullDistance / 2.0 - boltHeight / 2.0
    
    
        //scale to 100% at the beggining
        if pullDistance < 100 {
            self.boltImageView.transform = CGAffineTransform.identity
            self.boltImageView.frame.origin.y = boltY
            self.boltImageView.center = self.boltView.center
            self.boltImageView.bounds.size.height = pullDistance/100*45
            self.boltImageView.bounds.size.width = pullDistance/100*25

        }
        
        // rotate then
        if pullDistance > 100 {
            
            let angle = CGFloat(M_PI_2)*pullDistance/2000
            
            self.boltImageView.transform = self.boltImageView.transform.rotated(by: angle)

        }
        
        refreshBounds.size.height = pullDistance
        self.boltView.frame = refreshBounds
    
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if !hasFriend {
            
        self.performSegue(withIdentifier: "toAddView", sender: self)
            
        }
        else {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath)

        let indexPath = tableView.indexPathForSelectedRow!
        tableView.deselectRow(at: indexPath, animated: true)
        let currentCell = tableView.cellForRow(at: indexPath)! as UITableViewCell
        let name = currentCell.textLabel!.text
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        
        if reachable {
               ref.child("Users").child(userID!).observeSingleEvent(of: FIRDataEventType.value, with: { (snapshot) in
                if let snapshotValue = snapshot.value as? NSDictionary, let myName = snapshotValue["name"] as? String {
                    
                
                    let inputsOutputs : Dictionary<String, Any> = [
                "levelBattery" : String(batLevel.init().levelBat) as! NSString,
                "read" : false,
                "sent_by" : String(myName)as! NSString,
                "sent_date" : dateFormatter.string(from: date) as! NSString,
                "sent_to" :  String(name!) as! NSString
            ] as Dictionary<String, Any>
        
               
        FirebaseDataService.getUidWithUsername(name!,response: {(uid,exists)->() in
            
       ref.child("Users").child(uid).child("kaput").childByAutoId().setValue(inputsOutputs)
            
            })
                } else {
                    
                }
      })

        let boltImageAnimationView = SpringImageView(image: KaputStyle.imageOfBolt)

        currentCell.textLabel!.alpha = 0
        currentCell.backgroundView = boltImageAnimationView
        currentCell.backgroundView?.contentMode = .center
        boltImageAnimationView.animation = "slideLeft"
        boltImageAnimationView.animateTo()
        let triggerTime = (Int64(NSEC_PER_SEC) * 1)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(triggerTime) / Double(NSEC_PER_SEC), execute: { () -> Void in
        currentCell.textLabel!.alpha = 1
        currentCell.backgroundView = nil
      
        })

        FirebaseDataService.getKaputList(userID!,response: { (kaputCount) -> () in
            self.kaputCount = Int(kaputCount)
            
            self.kaputCounter.setTitle(String(self.kaputCount),for: UIControlState())
            
            if self.kaputCount == 1 {
                self.kaputCounter.animation = "slideRight"
                self.kaputCounter.animate()
            }

        })
        
        FirebaseDataService.sendMessageToName(name!)
//            kaputSent = kaputSent + 1
//            ref.child("Users").child(userID).child("kaputSent").setValue(kaputSent)
            
            ref.child("Users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
               
                if let snapshotValue = snapshot.value as? NSDictionary, let kaputSentOld = snapshotValue["kaputSent"] as? Int {
                
                let kaputSentNew = kaputSentOld + 1
            
            ref.child("Users").child(userID!).child("kaputSent").setValue(kaputSentNew)
                } else {
                    
                }
          })
    }
    else {
            notification.notificationLabelBackgroundColor = KaputStyle.lowRed
            notification.displayNotificationWithMessage("DUDE! GET A CONNECTION!", forDuration: 3.0)
            

        }
    }
    }
    
}
