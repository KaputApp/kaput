//
//  KaputStyleFactory.swift
//  
//
//  Created by Jeremy OUANOUNOU on 27/05/2016.
//
//

import UIKit

class batLevel{
    var levelBat:Int
    init() {
        UIDevice.currentDevice().batteryMonitoringEnabled = true
        self.levelBat = Int(abs(UIDevice.currentDevice().batteryLevel))*100;
    }
}

var batteryLevel = batLevel.init().levelBat

public class KaputStyleFactory: NSObject {
    
    
//public var primaryColor: UIColor!
//public var secondaryColor: UIColor!
//public var thirdColor: UIColor!

    
public class func setColors() {
var primaryColor: UIColor!
var secondaryColor: UIColor!
var bgColor: UIColor!
    
    if batteryLevel == 100 {
        bgColor = UIColor.blackColor()
        primaryColor = KaputStyle.lowRed
        secondaryColor = KaputStyle.fullGreen
        
        }
        
        
        
    }
    


    

}
