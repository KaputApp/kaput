//
//  FirebaseDataService.swift
//  kaput
//
//  Created by Jeremy OUANOUNOU on 12/06/2016.
//  Copyright © 2016 OPE50. All rights reserved.
// $(PRODUCT_BUNDLE_IDENTIFIER)

import UIKit
import FirebaseAuth
import Firebase
import FirebaseDatabase

struct FirebaseDataService {
    
    private enum ResourcePath: CustomStringConvertible {
        case Users
        case User(uid: String)
        case Friends(uid: String)
        case Kaputs(uid: String)
        case Kaput(uid: String, kaputId: String)
        case Blocked(uid: Int)
       
        var description: String {
            switch self {
            case .Users: return "Users"
            case .User(let uid): return "Users/\(uid)"
            case .Friends(let uid): return "Users/\(uid)/friends"
            case .Kaputs(let uid): return "Users/\(uid)/kaput"
            case .Kaput(let uid, let kaputId): return "Users/\(uid)/kaput/\(kaputId)"
            case .Blocked(let uid): return "Users/\(uid)/blocked"
            }
        }
    }
 


    static func getFriendList(uid: String, response: (friendList : NSDictionary) -> ()) {
    
        print("getFriendList is called")
        
        let friendsURL = ResourcePath.Friends(uid: uid).description
    
        
        ref.child(friendsURL).observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
            for child in snapshot.children {
                
                let childSnapshot = snapshot.childSnapshotForPath(child.key)
            }

            if snapshot.hasChildren(){
            let friendList = snapshot.value! as! NSDictionary
            response(friendList: friendList)
                 print(friendList)
            }
            else {let friendList = ["Tu n'as pas d'ami!":true]
                print(friendList)
                print(FIRAuth.auth()?.currentUser?.uid)
                response(friendList: friendList)
}
//
//            self.data =  friendList.allKeys as! [String]
//            self.friendsTableView.reloadData()
            
           
            print("getFriendList goes through")

            
        })
        
        
    }
    
    
    
    static func createUserData(uid: String, bat: String, username: String) {
        
    let user = ResourcePath.User(uid: uid).description
    ref.child(user).setValue(["userID": uid, "batteryLevel": bat, "isOnLine": "true", "name":username, "kaput" :"", "friends":"","instanceID":FIRInstanceID.instanceID().token()!])
    }
    
    static func userExists(uid: String, response: (userExists : Bool) -> ()) {
        let user = ResourcePath.User(uid: uid).description
        
        ref.child(user).observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
      
                let userExists = snapshot.exists()
                print(userExists)
                response(userExists : userExists)
                
            
})
}



    static func getUidWithUsername(name: String, response: (uid : String, exists:Bool) -> ()){
    
        let users = ResourcePath.Users.description
        var uid = String()
        var exists = Bool()
        ref.child(users).queryOrderedByChild("name").queryEqualToValue(name).observeSingleEventOfType(FIRDataEventType.Value, withBlock: { (snapshot) in
          print("snap = \(snapshot)")
            if snapshot.hasChildren(){
                for child in snapshot.children {
                    uid = child.key!
                    exists = true
                }
            } else {
                    exists = false
                }
            
            response(uid: uid,exists: exists)
        }){ (error) in
            print(error.localizedDescription)
            
        }
        

    
        
    }
   
    static func getInstanceIDwithuid(uid: String, response: (instanceID : String) -> ()){
        let user = ResourcePath.User(uid: uid).description
        var instanceID = String()
        ref.child(user).observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
        instanceID = snapshot.value!["instanceID"] as! String
        response(instanceID: instanceID)
        }){ (error) in
            print(error.localizedDescription)
    }
    }
    
    
    static func getKaputList(uid: String, response: (kaputCount : UInt) -> ()) {
        
            let kaputs = ResourcePath.Kaputs(uid: uid).description
            
            ref.child(kaputs).queryOrderedByChild("read").queryEqualToValue(false).observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
                if snapshot.hasChildren(){
                    print(snapshot)
                    let kaputCount = snapshot.childrenCount
                    
                    response(kaputCount : kaputCount)
                    
                }else{
                    let kaputCount = UInt(0)
                    response(kaputCount : kaputCount)
                    
                }
                
            })
            
        
        
    }
    
    static func sendMessageToName(name:String){
    getUidWithUsername(name,response: {(uid,exists)->() in
    getInstanceIDwithuid(uid,response: { (instanceID) -> () in
        sendMessage(instanceID,uid: uid)
    })
    })
    }
    
    
    
    static func sendMessage(instanceID: String){
        
        
        ref.child("Users").child(userID).observeSingleEventOfType(FIRDataEventType.Value, withBlock: { (snapshot) in
            let myName = snapshot.value?["name"] as? String
        
        
        
        let url = NSURL(string: "https://fcm.googleapis.com/fcm/send")
            let postParams: [String : AnyObject] = ["to": instanceID,"priority":"high","content_available" : true, "notification": ["body": "\(myName!) has \(batteryLevel)% of battery", "title": "You have a new Kaput","badge" : ""]]
        
            
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("key=AIzaSyAxHVl_jj4oyZrLw0aozMyk3b_msOvApSQ", forHTTPHeaderField: "Authorization")
            
        do
        {
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(postParams, options: NSJSONWritingOptions())
            print("My paramaters: \(postParams)")
        }
        catch
        {
            print("Caught an error: \(error)")
            }
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) in
            
            if let realResponse = response as? NSHTTPURLResponse
            {
                if realResponse.statusCode != 200
                {
                    print("Not a 200 response")
                }
            }
            
            if let postString = NSString(data: data!, encoding: NSUTF8StringEncoding) as? String
            {
                print("POST: \(postString)")
            }
            }
        
        task.resume()
        })}
 
    
}