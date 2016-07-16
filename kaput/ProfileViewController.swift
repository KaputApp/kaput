//
//  ProfileViewController.swift
//  kaput
//
//  Created by Jeremy OUANOUNOU on 15/07/2016.
//  Copyright © 2016 OPE50. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ProfileViewController: UIViewController {

    @IBAction func LogOut(sender: AnyObject) {
        
        try! FIRAuth.auth()!.signOut()
        performSegueWithIdentifier("logoutSegue", sender: self)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.init().bgColor
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
