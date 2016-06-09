//
//  NotificationViewController.swift
//  kaput
//
//  Created by Jeremy OUANOUNOU on 09/06/2016.
//  Copyright © 2016 OPE50. All rights reserved.
//

import UIKit

@IBDesignable

class NotificationViewController: UIViewController {

 
    @IBAction func shake(sender: AnyObject) {
        
        notifView.animation = "shake"
        notifView.animate()
    }
    @IBOutlet var notifView: SpringView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notifView.animation = "pop"
        notifView.animate()

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
