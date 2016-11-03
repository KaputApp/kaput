//
//  KaputStyleFactory.swift
//  
//
//  Created by OPE50 Team on 27/05/2016.
//
//

import UIKit
import Firebase


var batteryLevel = batLevel.init().levelBat
var stateBattery = batLevel.init().stateBat





open class SegueFromLeft: UIStoryboardSegue
{
    override open func perform() {
        let toViewController = destination
        let fromViewController = source
        
        let containerView = fromViewController.view.superview
        let screenBounds = UIScreen.main.bounds
        
        let finalToFrame = screenBounds
        let finalFromFrame = finalToFrame.offsetBy(dx: -screenBounds.size.width, dy: 0)
        
        toViewController.view.frame = finalToFrame.offsetBy(dx: screenBounds.size.width, dy: 0)
        containerView?.addSubview(toViewController.view)
        
        UIView.animate(withDuration: 0.25, animations: {
            toViewController.view.frame = finalToFrame
            fromViewController.view.frame = finalFromFrame
            }, completion: { finished in
                let fromVC = self.source
                let toVC = self.destination
                fromVC.present(toVC, animated: false, completion: nil)
        })
    }
}

open class SegueFromRight: UIStoryboardSegue
{
    override open func perform() {
        let toViewController = destination
        let fromViewController = source
        
        let containerView = fromViewController.view.superview
        let screenBounds = UIScreen.main.bounds
        
        let finalToFrame = screenBounds
        let finalFromFrame = finalToFrame.offsetBy(dx: screenBounds.size.width, dy: 0)
        
        toViewController.view.frame = finalToFrame.offsetBy(dx: -screenBounds.size.width, dy: 0)
        containerView?.addSubview(toViewController.view)
        
        UIView.animate(withDuration: 0.25, animations: {
            toViewController.view.frame = finalToFrame
            fromViewController.view.frame = finalFromFrame
            }, completion: { finished in
                let fromVC = self.source
                let toVC = self.destination
                fromVC.present(toVC, animated: false, completion: nil)
        })
    }
}


open class SegueFromUp: UIStoryboardSegue
{
    override open func perform() {
        let toViewController = destination
        let fromViewController = source
        
        let containerView = fromViewController.view.superview
        let screenBounds = UIScreen.main.bounds
        
        let finalToFrame = screenBounds
        let finalFromFrame = finalToFrame.offsetBy(dx: 0, dy: screenBounds.size.height)
        
        toViewController.view.frame = finalToFrame.offsetBy(dx: 0, dy: -screenBounds.size.height)
        containerView?.addSubview(toViewController.view)
        
        UIView.animate(withDuration: 0.5, animations: {
            toViewController.view.frame = finalToFrame
            fromViewController.view.frame = finalFromFrame
            }, completion: { finished in
                let fromVC = self.source
                let toVC = self.destination
                fromVC.present(toVC, animated: false, completion: nil)
        })
    }
}

open class SegueFromDown: UIStoryboardSegue
{
    override open func perform() {
        let toViewController = destination
        let fromViewController = source
        
        let containerView = fromViewController.view.superview
        let screenBounds = UIScreen.main.bounds
        
        let finalToFrame = screenBounds
        let finalFromFrame = finalToFrame.offsetBy(dx: 0, dy: -screenBounds.size.height)
        
        toViewController.view.frame = finalToFrame.offsetBy(dx: 0, dy: screenBounds.size.height)
        containerView?.addSubview(toViewController.view)
        
        UIView.animate(withDuration: 0.5, animations: {
            toViewController.view.frame = finalToFrame
            fromViewController.view.frame = finalFromFrame
            }, completion: { finished in
        })
    }
}




class batLevel{
    var levelBat:Int
    var stateBat:UIDeviceBatteryState
    init() {
        UIDevice.current.isBatteryMonitoringEnabled = true
        self.levelBat = Int(abs(UIDevice.current.batteryLevel)*100)
        self.stateBat = UIDevice.current.batteryState
        
    }
}


public func ColorsForBat(_ bat: Int) -> UIColor {
    
    var color = UIColor()
    
    switch bat {
    case 0...5:
    color =  KaputStyle.kaputBlack
    case  6...20:
    color =  KaputStyle.lowRed
    case 21...40:
    color =   KaputStyle.bloodyOrange
    case 41...80: 
    color =   KaputStyle.midYellow
        
    case 81...100:
    color =  KaputStyle.fullGreen
    default :

    color =   KaputStyle.chargingBlue
        
    }
    
    return color
}


open class Colors {
    
    
    var primaryColor: UIColor!
    var secondaryColor: UIColor!
    var bgColor: UIColor!
    var label : String
    
    
    init() {
       
        
        switch batLevel.init().stateBat {
    
    case UIDeviceBatteryState.unknown:
        
        switch batLevel.init().levelBat {
        case 0...5:
            self.bgColor = KaputStyle.kaputBlack
            self.primaryColor = KaputStyle.lowRed
            self.secondaryColor = KaputStyle.fullGreen
            self.label = "IT'S NOT TOO LATE"
            
        case 6...20:
            self.bgColor = KaputStyle.lowRed
            self.primaryColor = KaputStyle.chargingBlue
            self.secondaryColor = KaputStyle.fullGreen
            self.label = "CHARGE MEEEEE"
        case 21...40:
            self.bgColor = KaputStyle.bloodyOrange
            self.primaryColor = KaputStyle.lowRed
            self.secondaryColor = KaputStyle.fullGreen
            self.label = "TOO MUCH POKEMON GO?"

        case 41...80:
            self.bgColor = KaputStyle.midYellow
            self.primaryColor = KaputStyle.lowRed
            self.secondaryColor = KaputStyle.fullGreen
            self.label = "I'M OKAY."

        case 81...100:
            self.bgColor = KaputStyle.fullGreen
            self.primaryColor = KaputStyle.lowRed
            self.secondaryColor = KaputStyle.chargingBlue
            self.label = "THANKS FOR RESPECTING ME!"

        default :
            self.bgColor = KaputStyle.lowRed
            self.primaryColor = KaputStyle.chargingBlue
            self.secondaryColor = KaputStyle.fullGreen
            self.label = "I'VE NO IDEA WHAt TO SAY"

            
        }

        case UIDeviceBatteryState.unplugged:
            switch batLevel.init().levelBat {
                case 0...5:
                self.bgColor = KaputStyle.kaputBlack
                self.primaryColor = KaputStyle.lowRed
                self.secondaryColor = KaputStyle.fullGreen
                self.label = "IT'S NOT TOO LATE"

                case 6...20:
                self.bgColor = KaputStyle.lowRed
                self.primaryColor = KaputStyle.chargingBlue
                self.secondaryColor = KaputStyle.fullGreen
                self.label = "CHARGE MEEEEE"

                case 21...40:
                self.bgColor = KaputStyle.bloodyOrange
                self.primaryColor = KaputStyle.lowRed
                self.secondaryColor = KaputStyle.fullGreen
                self.label = "TOO MUCH POKEMON GO?"

                case 41...80:
                self.bgColor = KaputStyle.midYellow
                self.primaryColor = KaputStyle.lowRed
                self.secondaryColor = KaputStyle.fullGreen
                self.label = "I'M OKAY."

                case 81...100:
                self.bgColor = KaputStyle.fullGreen
                self.primaryColor = KaputStyle.lowRed
                self.secondaryColor = KaputStyle.chargingBlue
                self.label = "THANKS FOR RESPECTING ME!"
                default :
                self.bgColor = KaputStyle.lowRed
                self.primaryColor = KaputStyle.chargingBlue
                self.secondaryColor = KaputStyle.fullGreen
                self.label = "I'VE NO IDEA WHAt TO SAY"


            }
        case UIDeviceBatteryState.charging:
            self.bgColor = KaputStyle.chargingBlue
            self.primaryColor = KaputStyle.lowRed
            self.secondaryColor = KaputStyle.fullGreen
            self.label = "CHARGING YOUR PHONE. AWESOME IDEA."

            

        case UIDeviceBatteryState.full:
            self.bgColor = KaputStyle.fullGreen
            self.primaryColor = KaputStyle.lowRed
            self.secondaryColor = KaputStyle.chargingBlue
            self.label = "I'M SO FULL. GO BRAG ABOUT IT."

            
        
    
        }
    
        
    }
    
    
    
}
