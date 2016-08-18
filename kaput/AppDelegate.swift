//  AppDelegate.swift
//  kaput
//
//  Created by OPE50 Team on 26/05/2016.
//  Copyright © 2016 OPE50. All rights reserved.
//


import UIKit
import Firebase
import FirebaseAuth
import FirebaseInstanceID
import FirebaseMessaging
import FBSDKLoginKit

@UIApplicationMain


class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
		AppManager.sharedInstance.initRechabilityMonitor()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("friendListView")
        let vc2 = storyboard.instantiateViewControllerWithIdentifier("usernameViewController")
        // Register for remote notifications
        if #available(iOS 8.0, *) {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
        } else {
            // Fallback
            let types: UIRemoteNotificationType = [.Alert, .Badge, .Sound]
            application.registerForRemoteNotificationTypes(types)
        }
        
        
        FIRApp.configure()
    //    FIRDatabase.database().persistenceEnabled = true


    if ((FIRAuth.auth()!.currentUser) != nil){
    userID = String(FIRAuth.auth()!.currentUser!.uid)
        
    // Ici je fais le test sur firebase. Hors ca prend trop de temps, ce serait 100x meilleur de le faire en local.

        ref.child("Users").child(userID).child("name").observeSingleEventOfType(FIRDataEventType.Value, withBlock: { (snapshot) in
            if (snapshot.value as? String == ""){
               self.window?.rootViewController = vc2
            }else{
               self.window?.rootViewController = vc

            }
        })
        
    }
    
        // Add observer for InstanceID token refresh callback.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.tokenRefreshNotificaiton),
                                                         name: kFIRInstanceIDTokenRefreshNotification, object: nil)
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    //custom
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        if notificationSettings.types != .None {
            application.registerForRemoteNotifications()
        }
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }

    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let tokenChars = UnsafePointer<CChar>(deviceToken.bytes)
        var tokenString = ""
        
        for i in 0..<deviceToken.length {
            tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
        }
        
        //Tricky line
        FIRInstanceID.instanceID().setAPNSToken(deviceToken, type: FIRInstanceIDAPNSTokenType.Sandbox)

        
    }
    
    
    // [START receive_message]
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject],
                     fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        

        // Print full message.
        
        FIRMessaging.messaging().appDidReceiveMessage(userInfo)
    

    }
    // [END receive_message]
    
    // [START refresh_token]
    func tokenRefreshNotificaiton(notification: NSNotification) {

        
        // Connect to FCM since connection may have failed when attempted before having a token.
        connectToFcm()
    }
    // [END refresh_token]
    
    // [START connect_to_fcm]
    func connectToFcm() {

        FIRMessaging.messaging().connectWithCompletion { (error) in
            if (error != nil) {
                print("Unable to connect with FCM. \(error)")
            } else {
                print("Connected to FCM.")
                if let refreshedToken = FIRInstanceID.instanceID().token() {
               print("InstanceID token: \(refreshedToken)")
                }
            }
        }
    }
    // [END connect_to_fcm]
    
    func applicationDidBecomeActive(application: UIApplication) {
        
       connectToFcm()

        FBSDKAppEvents.activateApp()

    }
    
    // [START disconnect_from_fcm]
//    func applicationDidEnterBackground(application: UIApplication) {
//        FIRMessaging.messaging().disconnect()
//        print("Disconnected from FCM.")
//    }
    
    // [END disconnect_from_fcm]
}
