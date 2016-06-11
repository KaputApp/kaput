//
//  kaputPrimaryButton.swift
//  kaput
//
//  Created by Jeremy OUANOUNOU on 01/06/2016.
//  Copyright © 2016 OPE50. All rights reserved.
//

import UIKit


class kaputPrimaryButton: SpringButton {
   
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!

    self.layer.borderWidth = 5;
    self.layer.borderColor = UIColor.whiteColor().CGColor;
    self.layer.shadowColor = KaputStyle.shadowColor.CGColor;
    self.layer.shadowOffset = CGSizeMake(10, 10);
    self.layer.shadowRadius = 0
    self.layer.shadowOpacity = 1;
    self.layer.backgroundColor = Colors.init().primaryColor.CGColor
    
    }
    
    
    override func layoutSubviews() {
        
        if var titleFrame : CGRect = titleLabel?.frame{
            titleFrame.size = self.bounds.size
            titleFrame.origin = CGPointZero
            self.titleLabel!.frame = titleFrame
            self.titleLabel!.textAlignment = .Center
        }
    }
    
}
