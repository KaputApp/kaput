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
    var data = []
    var kaputCount = Int()
    var friendShown = [Bool]()
    var refreshControl: UIRefreshControl!
    var boltView : UIView!
    var boltImageView : UIImageView!



override func viewDidLoad() {
        super.viewDidLoad()

    ref.child("Users").child(userID).updateChildValues(["batteryLevel": batteryLevel])

    
        // populate the friendlist with the list of friend from firebase
        
        FirebaseDataService.getFriendList(userID,response: { (friendList) -> () in
            self.data =  friendList.allKeys as! [String]
            self.friendShown = [Bool](count: self.data.count, repeatedValue: false)

            self.friendsTableView.reloadData()
            
        })

        // get the list of kaputs
        FirebaseDataService.getKaputList(userID,response: { (kaputCount) -> () in
           
            self.kaputCount = Int(kaputCount)
            print(self.kaputCount)
       
        })
      
        // setting the kaputCount if we found some
        if kaputCount != 0 {
            self.kaputCounter.animation = "slideRight"
            self.kaputCounter.animate()
        }
        self.kaputCounter.setTitle(String(self.kaputCount),forState: UIControlState.Normal)
        
        // setting the bolt view
        self.setBoltView()

        // setting the view
    
        friendsTableView.delegate = self
        friendsTableView.dataSource = self
        friendsTableView.backgroundColor = Colors.init().bgColor
    
       // self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")

    
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
        cell.rightButtons = [MGSwipeButton(title: "Delete", backgroundColor: UIColor.redColor())
            ,MGSwipeButton(title: "More",backgroundColor: UIColor.blackColor())]
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
        let currentCell = tableView.cellForRowAtIndexPath(indexPath)! as UITableViewCell
        let name = currentCell.textLabel!.text
        
        let inputsOutputs = [
            "levelBattery" : String(batLevel.init().levelBat),
            "read" : true,
            "sent_by" : String(name!),
            "sent_date" : "NOW",
            "sent_to" : "ANDREA"
        ]
        cell.textLabel!.text = ""
        cell.textLabel!.text = "KAPUT SENT"

        FirebaseDataService.getKaputList(userID,response: { (kaputCount) -> () in
            self.kaputCount = Int(kaputCount)
            print(self.kaputCount)
        })
        
        ref.child("Users").child(userID).child("kaput").child(String(kaputCount+1)).setValue(inputsOutputs as [NSObject : AnyObject])
        print("addad")
        

        self.kaputCounter.setTitle(String(self.kaputCount+1),forState: UIControlState.Normal)
        
        if kaputCount == 0 {
            self.kaputCounter.animation = "slideRight"
            self.kaputCounter.animate()
        }
    }
    
}
