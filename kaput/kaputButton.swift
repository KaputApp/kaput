//
//  kaputButton.swift
//  kaput
//
//  Created by Jeremy OUANOUNOU on 01/06/2016.
//  Copyright © 2016 OPE50. All rights reserved.
//

import UIKit

class kaputButton: SpringButton {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        self.layer.borderWidth = 5;
        self.layer.borderColor = UIColor.white.cgColor;
        self.layer.shadowColor = KaputStyle.shadowColor.cgColor;
        self.layer.shadowOffset = CGSize(width: 10, height: 10);
        self.layer.shadowRadius = 0
        self.layer.shadowOpacity = 1;

        
    }

    override func layoutSubviews() {
       
    if var titleFrame : CGRect = titleLabel?.frame{
            titleFrame.size = self.bounds.size
            titleFrame.origin = CGPoint.zero
            self.titleLabel!.frame = titleFrame
            self.titleLabel!.textAlignment = .center
        }
    }
    
    
}




