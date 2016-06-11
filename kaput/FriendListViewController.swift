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
    var kaputCount = UInt()


    override func viewDidLoad() {
        super.viewDidLoad()

        
        ref.child("Users/xy2olnrUo2Wa5FY59c6KXIY4on62/friends").observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
            for child in snapshot.children {
                
                let childSnapshot = snapshot.childSnapshotForPath(child.key)
            }
            let friendList = snapshot.value! as! NSDictionary
            self.data =  friendList.allKeys as! [String]
            self.friendsTableView.reloadData()
            
        })
        

        self.kaputCounter.titleLabel?.text = String(kaputCount)
      
        ref.child("Users/xy2olnrUo2Wa5FY59c6KXIY4on62/kaput").observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
            
            self.kaputCount = snapshot.childrenCount
            print(snapshot.value!)
          
            })
        self.kaputCounter.titleLabel?.text = String(self.kaputCount)
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
        
        cell.textLabel!.text = "KAPUT SENT"
        
        let inputsOutputs = [
            "levelBattery" : String( batLevel.init().levelBat),
            "read" : true,
            "sent_by" : "JEREM",
            "sent_date" : "NOW",
            "sent_to" : "ANDREA"
        ]
        
        
        ref.child("Users/xy2olnrUo2Wa5FY59c6KXIY4on62/kaput").observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
            
           self.kaputCount = snapshot.childrenCount
        })
        
        ref.child("Users/xy2olnrUo2Wa5FY59c6KXIY4on62/kaput").child(String(kaputCount+1)).setValue(inputsOutputs as [NSObject : AnyObject])
        self.kaputCounter.titleLabel?.text = String(kaputCount)

        
        
        
    }
    
    
    
    
}
