//
//  FriendListViewController.swift
//  kaput
//
//  Created by Jeremy OUANOUNOU on 09/06/2016.
//  Copyright © 2016 OPE50. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseDatabase
import MGSwipeTableCell



class FriendListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
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
    
    ref.child("Users").child(userID).updateChildValues(["batteryLevel": batteryLevel])

    FirebaseDataService.getFriendList(userID,response: { (friendList) -> () in
        
        self.data =  friendList.allKeys  as! NSMutableArray
        self.friendShown = [Bool](count: self.data.count, repeatedValue: false)
        self.friendsTableView.reloadData()
            
    })

    FirebaseDataService.getKaputList(userID,response: { (kaputCount) -> () in
           
        self.kaputCount = Int(kaputCount)
        UIApplication.sharedApplication().applicationIconBadgeNumber = self.kaputCount

        if self.kaputCount != 0 {
            self.kaputCounter.hidden = false
            self.kaputCounter.animation = "slideRight"
            self.kaputCounter.animate()
        } else {
            self.kaputCounter.hidden = true
        }
            self.kaputCounter.setTitle(String(self.kaputCount),forState: UIControlState.Normal)
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
    
    
     func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return data.count
    }
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("friendCell", forIndexPath: indexPath)  as! MGSwipeTableCell
        
        //configure right buttons
        cell.rightButtons = [MGSwipeButton(title: "", icon: KaputStyle.imageOfTrashCan,backgroundColor: KaputStyle.lowRed,padding:30,callback: {
            (sender: MGSwipeTableCell!) -> Bool in
            //self.data.removeObjectAtIndex(indexPath.row)
            let name = tableView.cellForRowAtIndexPath(indexPath)?.textLabel?.text
            FirebaseDataService.removeFriend(name!)
            //tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Left)
            return true
       
        })]

        cell.rightSwipeSettings.transition = MGSwipeTransition.Drag
        
        cell.textLabel?.text = data[indexPath.row] as! String
       
        
        switch indexPath.row {
        case 1:
            cell.backgroundColor = KaputStyle.lowRed
        case 2:
            cell.backgroundColor = KaputStyle.fullGreen
        case 3:
            cell.backgroundColor = KaputStyle.chargingBlue
        case 0:
            cell.backgroundColor = KaputStyle.midYellow
        default:
            cell.backgroundColor = KaputStyle.lowRed
        }
        
      
        return cell
    }
    

    //ANIMATION CELL UP
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {

        if self.friendShown[indexPath.row] == false
        {
            let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, 0, UIScreen.mainScreen().bounds.height - 40*CGFloat(indexPath.row - 1), 0)
            cell.layer.transform = rotationTransform
        
            SpringAnimation.spring(1.5)
            {
            cell.layer.transform = CATransform3DIdentity
            }
            friendShown[indexPath.row] = true
        }

    }
    
    // BOLT VIEW
    
    func setBoltView() {
        
        
        self.refreshControl = UIRefreshControl()
        self.friendsTableView.addSubview(self.refreshControl)
        self.refreshControl?.addTarget(self, action: #selector(FriendListViewController.refresh), forControlEvents: UIControlEvents.ValueChanged)
       
        self.boltView = UIView(frame: self.refreshControl!.bounds)
        self.boltImageView = UIImageView(image: KaputStyle.imageOfBolt)
        self.boltView.addSubview(self.boltImageView)
        
        // Clip so the graphics don't stick out
        self.boltView.clipsToBounds = true;
        
        // center the image
        self.boltImageView.center = self.boltView.center
        
        print(boltImageView.center)

        
        // Hide the original spinner icon
        self.refreshControl!.tintColor = UIColor.clearColor()
        
        // Add the loading and colors views to our refresh control
        self.refreshControl!.addSubview(self.boltView)

    }
    
    func refresh(){

        performSegueWithIdentifier("profileSegue", sender: self)
        self.refreshControl!.endRefreshing()

    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
     
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
            self.boltImageView.transform = CGAffineTransformIdentity
            self.boltImageView.frame.origin.y = boltY
            self.boltImageView.center = self.boltView.center
            self.boltImageView.bounds.size.height = pullDistance/100*45
            self.boltImageView.bounds.size.width = pullDistance/100*25

        }
        
        // rotate then
        if pullDistance > 100 {
            
            let angle = CGFloat(M_PI_2)*pullDistance/2000
            self.boltImageView.transform = CGAffineTransformRotate(self.boltImageView.transform, angle)

        }
        
        refreshBounds.size.height = pullDistance
        self.boltView.frame = refreshBounds
    
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.dequeueReusableCellWithIdentifier("friendCell", forIndexPath: indexPath)
        
        let indexPath = tableView.indexPathForSelectedRow!
        tableView.deselectRowAtIndexPath(indexPath, animated: false)

        let currentCell = tableView.cellForRowAtIndexPath(indexPath)! as UITableViewCell
        let name = currentCell.textLabel!.text
        let date = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        
        ref.child("Users").child(userID).observeSingleEventOfType(FIRDataEventType.Value, withBlock: { (snapshot) in
            let myName = snapshot.value?["name"] as? String
           let inputsOutputs = [
                "levelBattery" : String(batLevel.init().levelBat),
                "read" : false,
                "sent_by" : String(myName!),
                "sent_date" : dateFormatter.stringFromDate(date),
                "sent_to" :  String(name!)
            ]
        
        FirebaseDataService.getUidWithUsername(name!,response: {(uid,exists)->() in
            
       ref.child("Users").child(uid).child("kaput").childByAutoId().setValue(inputsOutputs as [NSObject : AnyObject])

            })

      })
        
       
        
        cell.textLabel!.text = "KAPUT SENT"
        
        let triggerTime = (Int64(NSEC_PER_SEC) * 1)
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, triggerTime), dispatch_get_main_queue(), { () -> Void in
            cell.textLabel!.text = name
            
        })

        FirebaseDataService.getKaputList(userID,response: { (kaputCount) -> () in
            self.kaputCount = Int(kaputCount)
            print(self.kaputCount)
            self.kaputCounter.setTitle(String(self.kaputCount),forState: UIControlState.Normal)
            
            if self.kaputCount == 1 {
                self.kaputCounter.animation = "slideRight"
                self.kaputCounter.animate()
            }

        })
        
        FirebaseDataService.sendMessageToName(name!)

    }
    
}
