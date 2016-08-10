//
//  UIappViewController.swift
//  ReachOut
//
//  Created by FTS-MAC-017 on 07/01/16.
//  Copyright © 2016 Fingent Technology Solutions. All rights reserved.
//

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
	func reachabilityStatusChangeHandler(reachability: Reachability) {
     		if reachability.isReachable() {
			print("isReachable")
                notification.dismissNotification()
                reachable = true

		} else {
			print("notReachable")
            reachable = false


            notification.displayNotificationWithMessage("CHECK YOUR NETWORK CONNECTION", forDuration: 10.0)

		}
	}
}


