//
//  numberOfNotifications.swift
//  kaput
//
//  Created by Jeremy OUANOUNOU on 06/06/2016.
//  Copyright © 2016 OPE50. All rights reserved.
//

import UIKit

@IBDesignable

class numberOfNotifications: SpringButton {

    override func draw(_ rect: CGRect) {
        KaputStyle.drawNumberOfNotifications()
        
    }
    
    
    override func layoutSubviews() {
        
        if var titleFrame : CGRect = titleLabel?.frame{
            titleFrame.size = self.bounds.size
            titleFrame.origin = CGPoint(x: -10, y: -3)
            self.titleLabel!.frame = titleFrame
            self.titleLabel!.textAlignment = .center
        }
    }
    
    
}
