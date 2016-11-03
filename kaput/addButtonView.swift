//
//  addButtonView.swift
//  kaput
//
//  Created by Jeremy OUANOUNOU on 06/06/2016.
//  Copyright © 2016 OPE50. All rights reserved.
//

import UIKit

@IBDesignable

class addButtonView: SpringButton {
    
    override func draw(_ rect: CGRect) {
        KaputStyle.drawAddButton()
        
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
