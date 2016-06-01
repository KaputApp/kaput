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
    var stateBat:UIDeviceBatteryState
    init() {
        UIDevice.currentDevice().batteryMonitoringEnabled = true
        self.levelBat = Int(abs(UIDevice.currentDevice().batteryLevel)*100)
        self.stateBat = UIDevice.currentDevice().batteryState

    }
}

var batteryLevel = batLevel.init().levelBat
var stateBattery = batLevel.init().stateBat


public class Colors {
    
    
    var primaryColor: UIColor!
    var secondaryColor: UIColor!
    var bgColor: UIColor!
    
    init() {
        
        
        switch stateBattery {
    
    case UIDeviceBatteryState.Unknown:
        
        switch batteryLevel {
        case 0...5:
            self.bgColor = KaputStyle.lowRed
            self.primaryColor = KaputStyle.lowRed
            self.secondaryColor = KaputStyle.fullGreen
            
        case 6...20:
            self.bgColor = KaputStyle.lowRed
            self.primaryColor = KaputStyle.chargingBlue
            self.secondaryColor = KaputStyle.fullGreen
        case 21...40:
            self.bgColor = KaputStyle.chargingBlue
            self.primaryColor = KaputStyle.lowRed
            self.secondaryColor = KaputStyle.fullGreen
        case 41...80:
            self.bgColor = KaputStyle.lowRed
            self.primaryColor = KaputStyle.lowRed
            self.secondaryColor = KaputStyle.fullGreen
        case 81...100:
            self.bgColor = KaputStyle.fullGreen
            self.primaryColor = KaputStyle.lowRed
            self.secondaryColor = KaputStyle.chargingBlue
        default :
            self.bgColor = KaputStyle.fullGreen
            self.primaryColor = KaputStyle.lowRed
            self.secondaryColor = KaputStyle.chargingBlue
            
        }

        case UIDeviceBatteryState.Unplugged:
            switch batteryLevel {
            case 0...5:
                self.bgColor = KaputStyle.lowRed
                self.primaryColor = KaputStyle.lowRed
                self.secondaryColor = KaputStyle.fullGreen

            case 6...20:
                self.bgColor = KaputStyle.lowRed
                self.primaryColor = KaputStyle.chargingBlue
                self.secondaryColor = KaputStyle.fullGreen
            case 21...40:
                self.bgColor = KaputStyle.chargingBlue
                self.primaryColor = KaputStyle.lowRed
                self.secondaryColor = KaputStyle.fullGreen
            case 41...80:
                self.bgColor = KaputStyle.lowRed
                self.primaryColor = KaputStyle.lowRed
                self.secondaryColor = KaputStyle.fullGreen
            case 81...100:
                self.bgColor = KaputStyle.fullGreen
                self.primaryColor = KaputStyle.lowRed
                self.secondaryColor = KaputStyle.chargingBlue
                
            default:
                
                self.bgColor = KaputStyle.lowRed
                self.primaryColor = KaputStyle.lowRed
                self.secondaryColor = KaputStyle.fullGreen

            }
        case UIDeviceBatteryState.Charging:
            self.bgColor = KaputStyle.chargingBlue
            self.primaryColor = KaputStyle.lowRed
            self.secondaryColor = KaputStyle.fullGreen
            

        case UIDeviceBatteryState.Full:
            self.bgColor = KaputStyle.fullGreen
            self.primaryColor = KaputStyle.lowRed
            self.secondaryColor = KaputStyle.chargingBlue
            
        
    
        default:
        self.bgColor = KaputStyle.lowRed
        self.primaryColor = KaputStyle.lowRed
        self.secondaryColor = KaputStyle.fullGreen
        }
    
        
    }
    


    

}
