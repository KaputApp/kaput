//
//  UIappViewController.swift
//  ReachOut
//
//  Created by FTS-MAC-017 on 07/01/16.
//  Copyright © 2016 Fingent Technology Solutions. All rights reserved.
//

import UIKit

var manager:AppManager = AppManager.sharedInstance


class UIappViewController: UIViewController,AppManagerDelegate {

	override func viewDidLoad() {
		super.viewDidLoad()
		manager.delegate = self
	}
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	func reachabilityStatusChangeHandler(reachability: Reachability) {
        let notification = CWStatusBarNotification()
		if reachability.isReachable() {
			print("isReachable")
		} else {
			print("notReachable")

            notification.displayNotificationWithMessage("Check your network connection", forDuration: 1.0)
            
		}
	}
}


