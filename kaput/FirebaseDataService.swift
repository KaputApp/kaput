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
import FirebaseInstanceID
import FirebaseStorage
import FBSDKLoginKit


let letters = NSCharacterSet.alphanumericCharacterSet()

var kaputSent = Int()

var hasFriend = Bool()
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
 
    
    static func removeFriend( friend: String){
        ref.child("Users").child(userID).child("friends").child(friend).removeValue()
        
    }

    static func getFriendList(uid: String, response: (friendList : NSDictionary) -> ()) {
    
        
        let friendsURL = ResourcePath.Friends(uid: uid).description
    
        
        ref.child(friendsURL).observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
           
            if snapshot.hasChildren(){
            let friendList = snapshot.value! as! NSDictionary
            response(friendList: friendList)
                hasFriend  = true
            }
            else {
                hasFriend  = false

            let friendList = ["ADD FRIENDS !":true]
            response(friendList: friendList)
}

            
        })
        
        
    }
    
    
    static func createUserData(uid: String, bat: String, username: String, kaputSent: Int) {
    let user = ResourcePath.User(uid: uid).description
        
    ref.child(user).setValue(["userID": uid, "batteryLevel": bat, "isOnLine": "true", "name":username, "kaput" :"", "friends":"", "kaputSent": 0 ,"instanceID": FIRInstanceID.instanceID().token()!])
        
            storeAvatarInFirebase(UIImage(named:"AvatarBlue.jpg")!)
       
        
        
    }
    
    static func userExists(uid: String, response: (userExists : Bool) -> ()) {
        let user = ResourcePath.User(uid: uid).description
        
        ref.child(user).observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
      
                let userExists = snapshot.exists()
                response(userExists : userExists)
                
            
})
}

    static func getBatLevelWithName(name: String, response: (batLevel : Int) -> ()) {
        
        getUidWithUsername(name,response: {(uid,exists)->() in
            if exists {

        let user = ResourcePath.User(uid: uid).description
        var batLevel = Int()
        ref.child(user).child("batteryLevel").observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
                    batLevel = snapshot.value! as! Int
                    response(batLevel : batLevel)
             })
            } else { }
         })
        
        
    }
    
    static func getUidWithUsername(name: String, response: (uid : String, exists:Bool) -> ()){
    
        let users = ResourcePath.Users.description
        var uid = String()
        var exists = Bool()
        ref.child(users).queryOrderedByChild("name").queryEqualToValue(name).observeSingleEventOfType(FIRDataEventType.Value, withBlock: { (snapshot) in
         
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
    
    static func getName(response : (name : String) -> ()){
        ref.child("Users").child(userID).observeSingleEventOfType(FIRDataEventType.Value, withBlock: { (snapshot) in
            response(name:(snapshot.value?["name"] as? String)!)
        })
    }
   
    static func getInstanceIDwithuid(uid: String, response: (instanceID : String) -> ()){
        let user = ResourcePath.User(uid: uid).description
        var instanceID = String()
        ref.child(user).observeSingleEventOfType(FIRDataEventType.Value, withBlock: { (snapshot) in
        instanceID = snapshot.value!["instanceID"] as! String

            response(instanceID: instanceID)
        }){ (error) in
            print(error.localizedDescription)
    }
    }
    
    static func getAvatarFromFirebase(response: (image : UIImage) -> ()){
        
        let storage = FIRStorage.storage()
        let storageRef = storage.referenceForURL("gs://project-3561187186486872408.appspot.com/")
        let avatar = storageRef.child("Image/\(userID)/avatar.jpg")
        
        avatar.dataWithMaxSize(1 * 1024 * 1024) { (data, error) -> Void in
            if (error != nil) {
                print(error)
            } else {
                response(image: UIImage(data: data!)!)
            }
        }
    
    }
    

    
    static func storeAvatarInFirebase(image: UIImage){
    
    var storageRef = FIRStorage.storage().reference()
    let imagePath = "Image" + "/\(userID)" + "/avatar.jpg"
    let metadata = FIRStorageMetadata()
        metadata.contentType = "image/jpeg"
    let imageData = UIImageJPEGRepresentation(image, 0.8)

        storageRef.child(imagePath).putData(imageData!, metadata: metadata) { (metadata, error) in
                if let error = error {
                    print("Error uploading: \(error)")
                    return
                }
        
        }
    }
    
    
    static func getAvatarFromFB(response: (image : UIImage) -> ()){
        
        let params: [NSObject : AnyObject] = ["redirect": false, "height": 800, "width": 800, "type": "large"]
        let storage = FIRStorage.storage()
        let storageRef = storage.referenceForURL("gs://project-3561187186486872408.appspot.com/")
        let avatar = storageRef.child("Image/\(userID)/avatar.jpg")
        let filePath = "Image/\(userID)/avatar.jpg"
        var image = UIImage()
        let pictureRequest = FBSDKGraphRequest(graphPath: "me/picture", parameters: params, HTTPMethod: "GET")
        
        pictureRequest.startWithCompletionHandler({
            (connection, result, error: NSError!) -> Void in
            if error == nil {
                
                let dictionary = result as? NSDictionary
                let data = dictionary?.objectForKey("data")
                let urlPic = (data?.objectForKey("url"))! as! String
                print(urlPic)
              
            response(image: imageFromURL(urlPic)) 
                
            }else{
                print("\(error)")
            }
            
        })
        

        
        //        avatar.dataWithMaxSize(1 * 1024 * 1024) { (data, error) -> Void in
        //            if (error != nil) {
        //                print(error)
        //            } else {
        //                self.avatarImageView.image = UIImage(data: data!)
        //            }
        //        }
        //
        
    }
    
    static func getKaputList(uid: String, response: (kaputCount : UInt) -> ()) {
        
            let kaputs = ResourcePath.Kaputs(uid: uid).description
            
            ref.child(kaputs).queryOrderedByChild("read").queryEqualToValue(false).observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
                if snapshot.hasChildren(){
                    let kaputCount = snapshot.childrenCount
                    response(kaputCount : kaputCount)
                    
                }else{
                    let kaputCount = UInt(0)

                    response(kaputCount : kaputCount)
                    
                }
                
            })
            
        
        
    }
    
    
    static func getSingleKaputList(uid: String, response: (kaputCount : UInt) -> ()) {
        
        let kaputs = ResourcePath.Kaputs(uid: uid).description
        
        ref.child(kaputs).queryOrderedByChild("read").queryEqualToValue(false).observeSingleEventOfType(FIRDataEventType.Value, withBlock: { (snapshot) in
            if snapshot.hasChildren(){
                let kaputCount = snapshot.childrenCount
                
                response(kaputCount : kaputCount)
                
            }else{
                let kaputCount = UInt(0)
                response(kaputCount : kaputCount)
                
            }
            
        })
        
        
        
    }

    
    static func updateUsername(oldUsername: String, newUsername:String){
        
    // update my username
        let user = ResourcePath.User(uid: userID).description
       ref.child(user).updateChildValues(["name": newUsername])

    // update my username in friends list
     let users = ResourcePath.Users.description
       ref.child(users).queryOrderedByChild("friends/\(oldUsername)").queryEqualToValue(true).observeSingleEventOfType(FIRDataEventType.Value, withBlock: { (snapshot) in
        
        for child in snapshot.children {
            let inputsOutputs = [newUsername:true] as [String:Bool]
            ref.child("Users").child(child.key!).child("friends").updateChildValues(inputsOutputs)
            ref.child("Users").child(child.key!).child("friends").child(oldUsername).removeValue()
            
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
    
    static func sendFriendRequestToName(name: String){
        getUidWithUsername(name,response: {(uid,exists)->() in
            getInstanceIDwithuid(uid,response: { (instanceID) -> () in
                sendFriendrequest(instanceID,uid: uid)
            })
        })
    }
    
    
    static func sendFriendrequest(instanceID: String,uid: String){
        
        ref.child("Users").child(userID).observeSingleEventOfType(FIRDataEventType.Value, withBlock: { (snapshot) in
            getSingleKaputList(uid,response: { (kaputCount) -> () in
                
                let myName = snapshot.value?["name"] as? String
                let url = NSURL(string: "https://fcm.googleapis.com/fcm/send")
                let postParams: [String : AnyObject] = ["to": instanceID,"priority":"high","content_available" : true, "notification": ["body": "\(myName!) has added you!", "title": "You have a new Kaput Friend","badge" : "\(kaputCount)"]]
                
                
                
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
            })
        })
        
    }

    
    
    static func sendMessage(instanceID: String,uid: String){

       ref.child("Users").child(userID).observeSingleEventOfType(FIRDataEventType.Value, withBlock: { (snapshot) in
        getSingleKaputList(uid,response: { (kaputCount) -> () in
            
           let myName = snapshot.value?["name"] as? String
            let url = NSURL(string: "https://fcm.googleapis.com/fcm/send")
         let postParams: [String : AnyObject] = ["to": instanceID,"priority":"high","content_available" : true, "notification": ["body": "\(myName!) has \(batteryLevel)% of battery", "title": "You have a new Kaput","badge" : "\(kaputCount)"]]
        
        
            
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
        })
      })
        
    }
    
    
    
}