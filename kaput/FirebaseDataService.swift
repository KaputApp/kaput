//
//  FirebaseDataService.swift
//  kaput
//
//  Created by Jeremy OUANOUNOU on 12/06/2016.
//  Copyright © 2016 OPE50. All rights reserved.
//

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
             print("1/3")
            for child in snapshot.children {
                
                let childSnapshot = snapshot.childSnapshotForPath(child.key)
            }
            print("2/3")

            if snapshot.hasChildren(){
            let friendList = snapshot.value! as! NSDictionary
            response(friendList: friendList)
                 print(friendList)
            }
            else {let friendList = ["Tu n'a pas d'ami!":true]
                print(friendList)
                response(friendList: friendList)
}
//
//            self.data =  friendList.allKeys as! [String]
//            self.friendsTableView.reloadData()
            
           
            print("getFriendList goes through")

            
        })
        
        
    }
    
     static func getKaputList(uid: String, response: (kaputCount : UInt) -> ()) {
        let kaputs = ResourcePath.Kaputs(uid: uid).description
        
        ref.child(kaputs).observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
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
    
   static func createUserData(uid: String, bat: String, username: String) {
        
        let user = ResourcePath.User(uid: uid).description
       
        ref.child(user).setValue(["userID": uid, "batteryLevel": bat, "isOnLine": "true", "name":username, "kaput" :"", "friends":""])
        
    }

}


