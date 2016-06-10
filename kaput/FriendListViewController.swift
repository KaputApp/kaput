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

    override func viewDidLoad() {
        super.viewDidLoad()
        friendsTableView.delegate = self
        friendsTableView.dataSource = self
        friendsTableView.backgroundColor = Colors.init().bgColor

        
        ref.observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
            let postDict = snapshot.value as! [String : AnyObject]
            print(snapshot.value!)
            
            })
        
        
        
        
        }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    var data = ["ILLAN","ANDREA","JEREMY","DAVID","VINZ","NOEMIE","JEAN"]
  
    
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
        
        
        cell.textLabel?.text = data[indexPath.row]
        switch indexPath.row {
        case 1:
            cell.backgroundColor = KaputStyle.lowRed
        case 2:
            cell.backgroundColor = KaputStyle.fullGreen
        case 3:
            cell.backgroundColor = KaputStyle.chargingBlue
        case 4:
            cell.backgroundColor = KaputStyle.midYellow
        default:
            cell.backgroundColor = KaputStyle.lowRed
            
        }
        return cell
    }

    
    
    
}
