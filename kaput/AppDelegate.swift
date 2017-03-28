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
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
		AppManager.sharedInstance.initRechabilityMonitor()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "friendListView")
        let vc2 = storyboard.instantiateViewController(withIdentifier: "usernameViewController")
        // Register for remote notifications
        if #available(iOS 8.0, *) {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
        } else {
            // Fallback
            let types: UIRemoteNotificationType = [.alert, .badge, .sound]
            application.registerForRemoteNotifications(matching: types)
        }
        
        
        FIRApp.configure()
        FIRDatabase.database().persistenceEnabled = true
        
        UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
        


    if ((FIRAuth.auth()!.currentUser) != nil){
    userID = String(FIRAuth.auth()!.currentUser!.uid)
    
        print("au moment de l'appdelegate, userID est \(userID)")
        print("instanceID")
        print(FIRInstanceID.instanceID().token())
        
        self.window?.rootViewController = vc


        ref.child("Users").child(userID!).child("name").observeSingleEvent(of: FIRDataEventType.value, with: { (snapshot) in
            if (snapshot.value as? String == ""){
               self.window?.rootViewController = vc2
            }else{
               self.window?.rootViewController = vc

            }
        })
        
    }
    
        // Add observer for InstanceID token refresh callback.
        NotificationCenter.default.addObserver(self, selector: #selector(self.tokenRefreshNotificaiton),
                                                         name: NSNotification.Name.firInstanceIDTokenRefresh, object: nil)
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    //custom
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        if notificationSettings.types != UIUserNotificationType() {
            application.registerForRemoteNotifications()
        }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }

    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenChars = (deviceToken as NSData).bytes.bindMemory(to: CChar.self, capacity: deviceToken.count)
        var tokenString = ""
        
        for i in 0..<deviceToken.count {
            tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
        }
        
        //Tricky line
        FIRInstanceID.instanceID().setAPNSToken(deviceToken, type: FIRInstanceIDAPNSTokenType.prod)

        
    }
    
    
    // [START receive_message]
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        

        // Print full message.
        print("Bien reçu chef")
        FIRMessaging.messaging().appDidReceiveMessage(userInfo)
        ref.child("Users").child(userID!).updateChildValues(["batteryLevel": Int(abs(UIDevice.current.batteryLevel)*100)])
        print(userID!)
        print("Bat mise à jour au niveau \(String(Int(abs(UIDevice.current.batteryLevel)*100)))")

        
    }
    // [END receive_message]
    
    // [START refresh_token]
    func tokenRefreshNotificaiton(_ notification: Notification) {

        
        // Connect to FCM since connection may have failed when attempted before having a token.
        connectToFcm()
    }
    // [END refresh_token]
    
    // [START connect_to_fcm]
    func connectToFcm() {

        FIRMessaging.messaging().connect { (error) in
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
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
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
