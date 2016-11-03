//
//  AppManager.swift
//  ReachOut
//
//  Created by OPE50 Team on 07/01/16.
//

import UIKit
import Foundation
  var delegate:AppManagerDelegate? = nil

class AppManager: NSObject{
    open   var delegate:AppManagerDelegate? = nil
  fileprivate var _useClosures:Bool = false
  fileprivate var reachability: Reachability?
  fileprivate var _isReachability:Bool = false
  fileprivate var _reachabiltyNetworkType :String?

  var isReachability:Bool {
    get {return _isReachability}
  }
  var reachabiltyNetworkType:String {
    get {return _reachabiltyNetworkType! }
  }


  // Create a shared instance of AppManager
  final  class var sharedInstance : AppManager {
    struct Static {
      static var instance : AppManager?
    }
    if !(Static.instance != nil) {
      Static.instance = AppManager()

    }
    return Static.instance!
  }

  // Reachability Methods--------------------------------------------------------------------------------//
  func initRechabilityMonitor() {
    print("initialize rechability...")
    let reachability: Reachability

    do {
      reachability = try Reachability.init()!
      self.reachability = reachability
    } catch ReachabilityError.FailedToCreateWithAddress(let address) {
      print("Unable to create\nReachability with address:\n\(address)")
      return
    } catch {}
    if (_useClosures) {
      reachability.whenReachable = { reachability in
        self.notifyReachability(reachability)
      }
      reachability.whenUnreachable = { reachability in
        self.notifyReachability(reachability)
      }
    } else {
      self.notifyReachability(reachability)
    }

    do {
      try reachability.startNotifier()
    } catch {
      print("unable to start notifier")
      return
    }


  }

  fileprivate func notifyReachability(_ reachability:Reachability) {
    if reachability.isReachable {
      self._isReachability = true
        

      //Determine Network Type
        if reachability.isReachableViaWiFi {
        print("Reachable WIFI")
        self._reachabiltyNetworkType = CONNECTION_NETWORK_TYPE.WIFI_NETWORK.rawValue
      } else {
        self._reachabiltyNetworkType = CONNECTION_NETWORK_TYPE.WWAN_NETWORK.rawValue
      }

    } else {
      self._isReachability = false
      self._reachabiltyNetworkType = CONNECTION_NETWORK_TYPE.OTHER.rawValue
    }

     NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged),name: ReachabilityChangedNotification,object: reachability)
    }
  func reachabilityChanged(_ note: Notification) {
    let reachability = note.object as! Reachability
    DispatchQueue.main.async {
      self.delegate?.reachabilityStatusChangeHandler(reachability)

    }
  }
  deinit {
    reachability?.stopNotifier()
    if (!_useClosures) {
        NotificationCenter.default.removeObserver(self,
                                                  name: ReachabilityChangedNotification,
                                                  object: reachability)
    }
  }
}
