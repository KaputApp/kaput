//
//  labelButton.swift
//  kaput
//
//  Created by Jeremy OUANOUNOU on 10/08/2016.
//  Copyright © 2016 OPE50. All rights reserved.
//

import UIKit

class labelButton: UIButton {

    
    override func layoutSubviews() {
        
        if var titleFrame : CGRect = titleLabel?.frame{
            titleFrame.size = self.bounds.size
            titleFrame.origin = CGPoint.zero
            self.titleLabel!.frame = titleFrame
            self.titleLabel!.textAlignment = .center
        }
    }
    
}
