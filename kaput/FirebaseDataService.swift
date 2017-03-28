//
//  FirebaseDataService.swift
//  kaput
//
//  Created by Jeremy OUANOUNOU on 12/06/2016.
//  Copyright © 2016 OPE50. All rights reserved.
// $(PRODUCT_BUNDLE_IDENTIFIER)

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseInstanceID
import FirebaseStorage
import FBSDKLoginKit


let letters = CharacterSet.alphanumerics

var kaputSent = Int()

var hasFriend = Bool()
struct FirebaseDataService {
    
    fileprivate enum ResourcePath: CustomStringConvertible {
        case users
        case user(uid: String)
        case friends(uid: String)
        case kaputs(uid: String)
        case kaput(uid: String, kaputId: String)
        case blocked(uid: Int)
       
        var description: String {
            switch self {
            case .users: return "Users"
            case .user(let uid): return "Users/\(uid)"
            case .friends(let uid): return "Users/\(uid)/friends"
            case .kaputs(let uid): return "Users/\(uid)/kaput"
            case .kaput(let uid, let kaputId): return "Users/\(uid)/kaput/\(kaputId)"
            case .blocked(let uid): return "Users/\(uid)/blocked"
            }
        }
    }
 
    
    static func removeFriend( _ friend: String){
        ref.child("Users").child(userID!).child("friends").child(friend).removeValue()
        
    }

    static func getFriendList(_ uid: String, response: @escaping (_ friendList : NSDictionary) -> ()) {
    
        
        let friendsURL = ResourcePath.friends(uid: uid).description
    
        
        ref.child(friendsURL).observe(FIRDataEventType.value, with: { (snapshot) in
           
            if snapshot.hasChildren(){
           if let friendList = snapshot.value! as? NSDictionary {
            response(friendList)
                hasFriend  = true
            }else {}
            }
            else {
                hasFriend  = false

            let friendList = ["ADD FRIENDS !":true] as NSDictionary
            response(friendList)

}
            
        })
        
        
    }
    
    
    static func createUserData(_ uid: String, bat: String, username: String, kaputSent: Int) {
    let user = ResourcePath.user(uid: uid).description
       
        myUsername = username
        myAvatar = UIImage(named:"AvatarBlue.jpg")!
        
    ref.child(user).setValue(["userID": uid, "batteryLevel": bat, "isOnLine": "true", "name":username, "kaput" :"", "friends":"", "kaputSent": 0 ,"instanceID": FIRInstanceID.instanceID().token()!])
        
            storeAvatarInFirebase(UIImage(named:"AvatarBlue.jpg")!)
       
        
        
    }
    
    static func userExists(_ uid: String, response: @escaping (_ userExists : Bool) -> ()) {
        let user = ResourcePath.user(uid: uid).description
        
        ref.child(user).observe(FIRDataEventType.value, with: { (snapshot) in
      
                let userExists = snapshot.exists()
                response(userExists)
                
            
})
}

    static func getBatLevelWithName(_ name: String, response: @escaping (_ batLevel : Int) -> ()) {
        
        getUidWithUsername(name,response: {(uid,exists)->() in
            if exists {

        let user = ResourcePath.user(uid: uid).description
        var batLevel = Int()
        ref.child(user).child("batteryLevel").observe(FIRDataEventType.value, with: { (snapshot) in
                    
            if let snapshotValue = snapshot.value as? Int {
            batLevel = snapshotValue
                response(batLevel)}else{}
             })
            } else { }
         })
        
        
    }
    
    static func getUidWithUsername(_ name: String, response: @escaping (_ uid : String, _ exists:Bool) -> ()){
    
        let users = ResourcePath.users.description
        var uid = String()
        var exists = Bool()
        ref.child(users).queryOrdered(byChild: "name").queryEqual(toValue: name).observeSingleEvent(of: FIRDataEventType.value, with: { (snapshot) in
         
            if snapshot.hasChildren(){
                for child in snapshot.children {
                    uid = (child as AnyObject).key!
                    exists = true
                }
            } else {
                    exists = false
                }
            response(uid,exists)
        }){ (error) in
            print(error.localizedDescription)
            
        }
        

    
        
    }
    
    static func getName(_ response : @escaping (_ name : String) -> ()){
        ref.child("Users").child(userID!).observeSingleEvent(of: FIRDataEventType.value, with: { (snapshot) in

            if let snapshotValue = snapshot.value as? NSDictionary {
                response((snapshotValue["name"] as? String)!)}else{
            }
        })
    }
   
    static func getInstanceIDwithuid(_ uid: String, response: @escaping (_ instanceID : String) -> ()){
        let user = ResourcePath.user(uid: uid).description
        var instanceID = String()
        ref.child(user).observeSingleEvent(of: FIRDataEventType.value, with: { (snapshot) in
            
         if let snapshotValue = snapshot.value as? NSDictionary {
        instanceID = snapshotValue["instanceID"] as! String

            response(instanceID)}else{}
        }){ (error) in
            print(error.localizedDescription)
    }
    }
    
    static func getAvatarFromFirebase(_ response: @escaping (_ image : UIImage) -> ()){
        
        let storage = FIRStorage.storage()
        let storageRef = storage.reference(forURL: "gs://project-3561187186486872408.appspot.com/")
        let avatar = storageRef.child("Image/\(userID!)/avatar.jpg")
        
        avatar.data(withMaxSize: 1 * 1024 * 1024) { (data, error) -> Void in
            if (error != nil) {
                print(error)
            } else {
                response(UIImage(data: data!)!)
            }
        }
    
    }
    

    
    static func storeAvatarInFirebase(_ image: UIImage){
    
    let storageRef = FIRStorage.storage().reference()
    let imagePath = "Image" + "/\(userID!)" + "/avatar.jpg"
    let metadata = FIRStorageMetadata()
        metadata.contentType = "image/jpeg"
    let imageData = UIImageJPEGRepresentation(image, 0.8)

        storageRef.child(imagePath).put(imageData!, metadata: metadata) { (metadata, error) in
                if let error = error {
                    print("Error uploading: \(error)")
                    return
                }
        
        }
    }
    
    
    static func getAvatarFromFB(_ response: @escaping (_ image : UIImage) -> ()){
        
        let params: [AnyHashable: Any] = ["redirect": false, "height": 800, "width": 800, "type": "large"]
        let storage = FIRStorage.storage()
        let storageRef = storage.reference(forURL: "gs://project-3561187186486872408.appspot.com/")
        let avatar = storageRef.child("Image/\(userID!)/avatar.jpg")
        let pictureRequest = FBSDKGraphRequest(graphPath: "me/picture", parameters: params, httpMethod: "GET")
        
        // AVATAR
        
//        pictureRequest?.startWithCompletionHandler({
//            (connection, result, error: NSError!) -> Void in
//            if error == nil {
//
//        let dictionary = result as? NSDictionary
//        let data = dictionary?.object(forKey: "data")
//        let urlPic = ((data as AnyObject).object(forKey: "url"))! as! String
//        print(urlPic)
//        
//        response(imageFromURL(urlPic))
//
//            }else{
//                print("\(error)")
//            }
//            
//        })
//        
        pictureRequest?.start (completionHandler: { connection, result, error in
            if error != nil {
                //onError()
                print(error)
                return
            } else {
                //get results
                
                let dictionary = result as? NSDictionary
                let data = dictionary?.object(forKey: "data")
                let urlPic = ((data as AnyObject).object(forKey: "url"))! as! String
                print(urlPic)
                
                response(imageFromURL(urlPic))
            }
        })
        

        
//                avatar.data(withMaxSize: 1 * 1024 * 1024) { (data, error) -> Void in
//                    if (error != nil) {
//                        print(error)
//                    } else {
//                        self.avatarImageView.image = UIImage(data: data!)
//                    }
//                }
        
        
    }
    
    static func getKaputList(_ uid: String, response: @escaping (_ kaputCount : UInt) -> ()) {
        
            let kaputs = ResourcePath.kaputs(uid: uid).description
            
            ref.child(kaputs).queryOrdered(byChild: "read").queryEqual(toValue: false).observe(FIRDataEventType.value, with: { (snapshot) in
                if snapshot.hasChildren(){
                    let kaputCount = snapshot.childrenCount
                    response(kaputCount)
                    
                }else{
                    let kaputCount = UInt(0)

                    response(kaputCount)
                    
                }
                
            })
            
        
        
    }
    
    
    static func getSingleKaputList(_ uid: String, response: @escaping (_ kaputCount : UInt) -> ()) {
        
        let kaputs = ResourcePath.kaputs(uid: uid).description
        
        ref.child(kaputs).queryOrdered(byChild: "read").queryEqual(toValue: false).observeSingleEvent(of: FIRDataEventType.value, with: { (snapshot) in
            if snapshot.hasChildren(){
                let kaputCount = snapshot.childrenCount
                
                response(kaputCount)
                
            }else{
                let kaputCount = UInt(0)
                response(kaputCount)
                
            }
            
        })
        
        
        
    }

    
    static func updateUsername(_ oldUsername: String, newUsername:String){
        
    // update my username
        let user = ResourcePath.user(uid: userID!).description
       ref.child(user).updateChildValues(["name": newUsername])

    // update my username in friends list
     let users = ResourcePath.users.description
       ref.child(users).queryOrdered(byChild: "friends/\(oldUsername)").queryEqual(toValue: true).observeSingleEvent(of: FIRDataEventType.value, with: { (snapshot) in
        
        for child in snapshot.children {
            let inputsOutputs = [newUsername:true] as [String:Bool]
            ref.child("Users").child((child as AnyObject).key!).child("friends").updateChildValues(inputsOutputs)
            ref.child("Users").child((child as AnyObject).key!).child("friends").child(oldUsername).removeValue()
            
        }
        
        })
    }
    
    static func sendMessageToName(_ name:String){
    getUidWithUsername(name,response: {(uid,exists)->() in
    getInstanceIDwithuid(uid,response: { (instanceID) -> () in
        sendMessage(instanceID,uid: uid)
    })  
    })
    }
    
    static func sendSilentToName(_ name:String){
        getUidWithUsername(name,response: {(uid,exists)->() in
            getInstanceIDwithuid(uid,response: { (instanceID) -> () in
                sendSilent(instanceID,uid: uid)
            })
        })
    }
    
    static func sendFriendRequestToName(_ name: String){
        getUidWithUsername(name,response: {(uid,exists)->() in
            getInstanceIDwithuid(uid,response: { (instanceID) -> () in
                sendFriendrequest(instanceID,uid: uid)
            })
        })
    }
    
    
    static func sendFriendrequest(_ instanceID: String,uid: String){
        
        ref.child("Users").child(userID!).observeSingleEvent(of: FIRDataEventType.value, with: { (snapshot) in
            getSingleKaputList(uid,response: { (kaputCount) -> () in
                if let snapshotValue = snapshot.value as? NSDictionary {

                let myName = snapshotValue["name"] as? String
                let url = URL(string: "https://fcm.googleapis.com/fcm/send")
                let postParams: [String : Any] = ["to": instanceID,"priority":"high","content_available" : true, "notification": ["body": "\(myName!) added you as a friend !", "title": "You have a new Kaput Friend","badge" : "\(kaputCount)"]]
                
                
                
                let request = NSMutableURLRequest(url: url!)
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.setValue("key=AIzaSyAxHVl_jj4oyZrLw0aozMyk3b_msOvApSQ", forHTTPHeaderField: "Authorization")
                
                do
                {
                    request.httpBody = try JSONSerialization.data(withJSONObject: postParams, options: JSONSerialization.WritingOptions())
                    print("My paramaters: \(postParams)")
                }
                catch
                {
                    print("Caught an error: \(error)")
                }
                    
                
                let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
                    
                    if let realResponse = response as? HTTPURLResponse
                    {
                        if realResponse.statusCode != 200
                        {
                            print("Not a 200 response")
                        }
                    }
                    
                    if let postString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue) as? String
                    {
                        print("POST: \(postString)")
                    }
                })
                task.resume()
                } })
        })
        
    }

    
    
    static func sendMessage(_ instanceID: String,uid: String){

       ref.child("Users").child(userID!).observeSingleEvent(of: FIRDataEventType.value, with: { (snapshot) in
        getSingleKaputList(uid,response: { (kaputCount) -> () in
             if let snapshotValue = snapshot.value as? NSDictionary {
           let myName = snapshotValue["name"] as? String
            let url = URL(string: "https://fcm.googleapis.com/fcm/send")
         let postParams: Dictionary<String, Any> = ["to": instanceID,"priority":"high","content_available" : true, "notification": ["body": "\(myName!) has \(batteryLevel)% of battery", "title": "You have a new Kaput","badge" : "\(kaputCount)"]]
        
            
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("key=AIzaSyAxHVl_jj4oyZrLw0aozMyk3b_msOvApSQ", forHTTPHeaderField: "Authorization")
            
        do
        {
            request.httpBody = try JSONSerialization.data(withJSONObject: postParams, options: JSONSerialization.WritingOptions())
            print("My paramaters: \(postParams)")
        }
        catch
        {
            print("Caught an error: \(error)")
        }
        
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
            
            if let realResponse = response as? HTTPURLResponse
            {
                if realResponse.statusCode != 200
                {
                    print("Not a 200 response")
                }
            }
            
            if let postString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue) as? String
            {
                print("POST: \(postString)")
            }
        }) 
        
        task.resume()
            }   })
      })
        
    }
    
    static func sendSilent(_ instanceID: String,uid: String){
        
        ref.child("Users").child(userID!).observeSingleEvent(of: FIRDataEventType.value, with: { (snapshot) in
                if let snapshotValue = snapshot.value as? NSDictionary {
                    let myName = snapshotValue["name"] as? String
                    let url = URL(string: "https://fcm.googleapis.com/fcm/send")
                    let postParams: Dictionary<String, Any> = ["to": instanceID, "priority" : "high","content_available" : true,"notification": [
                        "sound": ""]
                        ]
                    
                    let request = NSMutableURLRequest(url: url!)
                    request.httpMethod = "POST"
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    request.setValue("key=AIzaSyAxHVl_jj4oyZrLw0aozMyk3b_msOvApSQ", forHTTPHeaderField: "Authorization")
                    
                    do
                    {
                        request.httpBody = try JSONSerialization.data(withJSONObject: postParams, options: JSONSerialization.WritingOptions())
                        print("My paramaters: \(postParams)")
                    }
                    catch
                    {
                        print("Caught an error: \(error)")
                    }
                    
                    let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
                        
                        if let realResponse = response as? HTTPURLResponse
                        {
                            if realResponse.statusCode != 200
                            {
                                print("Not a 200 response")
                            }
                        }
                        
                        if let postString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue) as? String
                        {
                            print("POST: \(postString)")
                        }
                    }) 
                    
                    task.resume()
                }   })
        
        
    }
    
    
}
