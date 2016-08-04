//
//  KaputStyleFactory.swift
//  
//
//  Created by Jeremy OUANOUNOU on 27/05/2016.
//
//

import UIKit
import Firebase


var batteryLevel = batLevel.init().levelBat
var stateBattery = batLevel.init().stateBat





public class SegueFromLeft: UIStoryboardSegue
{
    override public func perform() {
        let toViewController = destinationViewController
        let fromViewController = sourceViewController
        
        let containerView = fromViewController.view.superview
        let screenBounds = UIScreen.mainScreen().bounds
        
        let finalToFrame = screenBounds
        let finalFromFrame = CGRectOffset(finalToFrame, -screenBounds.size.width, 0)
        
        toViewController.view.frame = CGRectOffset(finalToFrame, screenBounds.size.width, 0)
        containerView?.addSubview(toViewController.view)
        
        UIView.animateWithDuration(0.25, animations: {
            toViewController.view.frame = finalToFrame
            fromViewController.view.frame = finalFromFrame
            }, completion: { finished in
                let fromVC = self.sourceViewController
                let toVC = self.destinationViewController
                fromVC.presentViewController(toVC, animated: false, completion: nil)
        })
    }
}

public class SegueFromRight: UIStoryboardSegue
{
    override public func perform() {
        let toViewController = destinationViewController
        let fromViewController = sourceViewController
        
        let containerView = fromViewController.view.superview
        let screenBounds = UIScreen.mainScreen().bounds
        
        let finalToFrame = screenBounds
        let finalFromFrame = CGRectOffset(finalToFrame, screenBounds.size.width, 0)
        
        toViewController.view.frame = CGRectOffset(finalToFrame, -screenBounds.size.width, 0)
        containerView?.addSubview(toViewController.view)
        
        UIView.animateWithDuration(0.25, animations: {
            toViewController.view.frame = finalToFrame
            fromViewController.view.frame = finalFromFrame
            }, completion: { finished in
                let fromVC = self.sourceViewController
                let toVC = self.destinationViewController
                fromVC.presentViewController(toVC, animated: false, completion: nil)
        })
    }
}


public class SegueFromUp: UIStoryboardSegue
{
    override public func perform() {
        let toViewController = destinationViewController
        let fromViewController = sourceViewController
        
        let containerView = fromViewController.view.superview
        let screenBounds = UIScreen.mainScreen().bounds
        
        let finalToFrame = screenBounds
        let finalFromFrame = CGRectOffset(finalToFrame, 0, screenBounds.size.height)
        
        toViewController.view.frame = CGRectOffset(finalToFrame,0, -screenBounds.size.height)
        containerView?.addSubview(toViewController.view)
        
        UIView.animateWithDuration(0.5, animations: {
            toViewController.view.frame = finalToFrame
            fromViewController.view.frame = finalFromFrame
            }, completion: { finished in
                let fromVC = self.sourceViewController
                let toVC = self.destinationViewController
                fromVC.presentViewController(toVC, animated: false, completion: nil)
        })
    }
}

public class SegueFromDown: UIStoryboardSegue
{
    override public func perform() {
        let toViewController = destinationViewController
        let fromViewController = sourceViewController
        
        let containerView = fromViewController.view.superview
        let screenBounds = UIScreen.mainScreen().bounds
        
        let finalToFrame = screenBounds
        let finalFromFrame = CGRectOffset(finalToFrame, 0, -screenBounds.size.height)
        
        toViewController.view.frame = CGRectOffset(finalToFrame,0, screenBounds.size.height)
        containerView?.addSubview(toViewController.view)
        
        UIView.animateWithDuration(0.5, animations: {
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
        UIDevice.currentDevice().batteryMonitoringEnabled = true
        self.levelBat = Int(abs(UIDevice.currentDevice().batteryLevel)*100)
        self.stateBat = UIDevice.currentDevice().batteryState
        
    }
}


public func ColorsForBat(bat: Int) -> UIColor {
    
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


public class Colors {
    
    
    var primaryColor: UIColor!
    var secondaryColor: UIColor!
    var bgColor: UIColor!
    var label : String
    
    
    init() {
       
        
        switch batLevel.init().stateBat {
    
    case UIDeviceBatteryState.Unknown:
        
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

        case UIDeviceBatteryState.Unplugged:
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
        case UIDeviceBatteryState.Charging:
            self.bgColor = KaputStyle.chargingBlue
            self.primaryColor = KaputStyle.lowRed
            self.secondaryColor = KaputStyle.fullGreen
            self.label = "CHARGING YOUR PHONE. AWESOME IDEA."

            

        case UIDeviceBatteryState.Full:
            self.bgColor = KaputStyle.fullGreen
            self.primaryColor = KaputStyle.lowRed
            self.secondaryColor = KaputStyle.chargingBlue
            self.label = "I'M SO FULL. GO BRAG ABOUT IT."

            
        
    
        }
    
        
    }
    
    
    
}
