//
//  UIappViewController.swift
//  ReachOut
//
//  Created by OPE50 Team on 07/01/16.
import UIKit

var manager:AppManager = AppManager.sharedInstance
let notification = CWStatusBarNotification()
var reachable = true

class UIappViewController: UIViewController,AppManagerDelegate {

	override func viewDidLoad() {
		super.viewDidLoad()
		manager.delegate = self
	}
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	func reachabilityStatusChangeHandler(_ reachability: Reachability) {
     		if reachability.isReachable {
			
                notification.dismissNotification()
                reachable = true

		} else {
			
            reachable = false


            notification.displayNotificationWithMessage("CHECK YOUR NETWORK CONNECTION", forDuration: 10.0)

		}
	}
}


