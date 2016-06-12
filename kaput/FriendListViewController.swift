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


    override func viewDidLoad() {
        super.viewDidLoad()

        print("jusque la ca va")
            FirebaseDataService.getFriendList(userID,response: { (friendList) -> () in
                
            self.data =  friendList.allKeys as! [String]
            self.friendsTableView.reloadData()
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
            print("coumpter")
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
