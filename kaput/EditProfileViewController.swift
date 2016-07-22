//
//  EditProfileViewController.swift
//  
//
//  Created by Jeremy OUANOUNOU on 22/07/2016.
//
//

import UIKit

class EditProfileViewController: UIViewController {

    @IBOutlet var mailField: kaputField!
    override func viewDidLoad() {
        
        super.viewDidLoad()
            mailField.becomeFirstResponder()
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
