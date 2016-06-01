//
//  SignInViewController.swift
//  kaput
//
//  Created by Jeremy OUANOUNOU on 01/06/2016.
//  Copyright © 2016 OPE50. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {

    @IBOutlet var usernameField: kaputField!
    @IBAction func logInButton(sender: AnyObject) {
            self.performSegueWithIdentifier("showUserList", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    usernameField.becomeFirstResponder()

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
