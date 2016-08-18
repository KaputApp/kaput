//
//  FBData.swift
//  
//
//  Created by OPE50 Team on 10/06/2016.
//
//

import UIKit

class FBData: NSObject {
    
    var userID = FIRAuth.auth()?.currentUser?.uid
    
    var Snap = ref.child("Users").child("xy2olnrUo2Wa5FY59c6KXIY4on62").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
        // Get user value
        print(snapshot.value!)
        
        // ...
    }) { (error) in
        print(error.localizedDescription)
    }
    


}
