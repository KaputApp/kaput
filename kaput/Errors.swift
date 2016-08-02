//
//  errorLabel.swift
//  kaput
//
//  Created by Jeremy OUANOUNOU on 02/08/2016.
//  Copyright © 2016 OPE50. All rights reserved.
//

import UIKit

public class Errors {
    
    
static func errorMessage(text: String,field: kaputField){
        
        let err: PaddingLabel = PaddingLabel()
        
        err.opacity = 0
        err.backgroundColor = KaputStyle.midYellow
        err.textColor = UIColor.whiteColor()
        err.duration = 1
        err.font = UIFont(name: "Futura-Condensed", size: 18.0 )
        err.animation = "fadeInRight"
    
        err.text = text
        err.frame =  CGRectMake(0,0,field.frame.width,field.frame.height)
        err.sizeToFit()
        err.frame =  CGRectMake(0,0,err.frame.width + 10,field.frame.height-2)
        err.textAlignment = .Center
        err.topInset = 9
        err.setNeedsDisplay()
        err.frame.origin.x = field.frame.width - err.frame.width
        err.frame.origin.y = err.frame.origin.y - 6

        field.addSubview(err)
        err.animate()
    
    }

    static func clearErrors(field: kaputField){
    
        for subview in field.subviews {
            if subview.isKindOfClass(PaddingLabel){
            subview.removeFromSuperview()
            }
        }
    
    }
    
    
    static func validateEmail(candidate: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluateWithObject(candidate)
    }

    
    
}