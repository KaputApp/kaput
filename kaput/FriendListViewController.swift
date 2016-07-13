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



class FriendListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    @IBOutlet weak var friendsTableView: UITableView!
    @IBOutlet var kaputCounter: numberOfNotifications!
    var data = []
    var kaputCount = Int()
    var friendShown = [Bool]()
    var refreshControl: UIRefreshControl!
    var boltView : UIView!
    var boltImageView : UIImageView!



    override func viewDidLoad() {
        super.viewDidLoad()
        
        
            FirebaseDataService.getFriendList(userID,response: { (friendList) -> () in
            self.data =  friendList.allKeys as! [String]
            self.friendShown = [Bool](count: self.data.count, repeatedValue: false)

            self.friendsTableView.reloadData()
            self.setBoltView()
                
            })

        
        
//        ref.child("Users/060bNfcSN8ZTmYHMvqG0QyMm8X42/friends").observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
//            for child in snapshot.children {
//                
//                let childSnapshot = snapshot.childSnapshotForPath(child.key)
//            }
//            let friendList = snapshot.value! as! NSDictionary
//            self.data =  friendList.allKeys as! [String]
//            self.friendsTableView.reloadData()
//            
//        })
        
        FirebaseDataService.getKaputList(userID,response: { (kaputCount) -> () in
            self.kaputCount = Int(kaputCount)
            print(self.kaputCount)
        })
      
//        ref.child("Users/060bNfcSN8ZTmYHMvqG0QyMm8X42/kaput").observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
//            
//            self.kaputCount = snapshot.childrenCount
//          
//            })

        if kaputCount != 0 {
            self.kaputCounter.animation = "slideRight"
            self.kaputCounter.animate()
        }
        
        self.kaputCounter.setTitle(String(self.kaputCount),forState: UIControlState.Normal)
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
        let cell = tableView.dequeueReusableCellWithIdentifier("friendCell", forIndexPath: indexPath)
        
        
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

        
        // Hide the original spinner icon
        self.refreshControl!.tintColor = UIColor.clearColor()
        
        // Add the loading and colors views to our refresh control
        self.refreshControl!.addSubview(self.boltView)

    }
    
    func refresh(){
        

        performSegueWithIdentifier("profileSegue", sender: self)
        self.refreshControl!.endRefreshing()
       // self.boltImageView.transform = CGAffineTransformIdentity

    }
    

    
    func scrollViewDidScroll(scrollView: UIScrollView) {
     
        // Get the current size of the refresh controller
        var refreshBounds = self.refreshControl!.bounds;
        

        
        // Distance the table has been pulled >= 0
        var pullDistance = max(0.0, -self.refreshControl!.frame.origin.y);
        
        
        
        
        var boltHeight = self.boltImageView.bounds.size.height
        var boltWidth = self.boltImageView.bounds.size.width
        var boltY = pullDistance / 2.0 - boltHeight / 2.0
    
    
        if pullDistance < 100 {
            self.boltImageView.transform = CGAffineTransformIdentity
            self.boltImageView.frame.origin.y = boltY
            self.boltImageView.bounds.size.height = pullDistance/100*45
            self.boltImageView.bounds.size.width = pullDistance/100*25

        }
        
        
        
        if pullDistance > 100 {
            
            let angle = CGFloat(M_PI_2)*pullDistance/2000
            self.boltImageView.transform = CGAffineTransformRotate(self.boltImageView.transform, angle)

        }
        
        refreshBounds.size.height = pullDistance
        self.boltView.frame = refreshBounds
        
        
        
    
    

    
        
    
   // CGAffineTransformRotate(self.boltImageView.transform, angle)
        
    }
    
   
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("friendCell", forIndexPath: indexPath)
        
        let indexPath = tableView.indexPathForSelectedRow!
        let currentCell = tableView.cellForRowAtIndexPath(indexPath)! as UITableViewCell
        let name = currentCell.textLabel!.text
        
        let inputsOutputs = [
            "levelBattery" : String(batLevel.init().levelBat),
            "read" : true,
            "sent_by" : String(name!),
            "sent_date" : "NOW",
            "sent_to" : "ANDREA"
        ]
        
        cell.textLabel!.text = "KAPUT SENT"

        
        FirebaseDataService.getKaputList(userID,response: { (kaputCount) -> () in
            self.kaputCount = Int(kaputCount)
            print(self.kaputCount)
        })
        
        
//        ref.child("Users/060bNfcSN8ZTmYHMvqG0QyMm8X42/kaput").observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
//            
//           self.kaputCount = snapshot.childrenCount
//        })
        
        ref.child("Users").child(userID).child("kaput").child(String(kaputCount+1)).setValue(inputsOutputs as [NSObject : AnyObject])
        print("addad")
        

        self.kaputCounter.setTitle(String(self.kaputCount+1),forState: UIControlState.Normal)
        
        if kaputCount == 0 {
            self.kaputCounter.animation = "slideRight"
            self.kaputCounter.animate()
        }

        
        
        
    }
    
    
    
    
}
