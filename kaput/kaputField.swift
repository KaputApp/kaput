//
//  kaputField.swift
//  kaput
//
//  Created by Jeremy OUANOUNOU on 01/06/2016.
//  Copyright © 2016 OPE50. All rights reserved.
//

import UIKit

class kaputField: UITextField {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        createBorder()
    }
    
    func createBorder(){
        let border = CALayer()
        let width = CGFloat(3.0)
        border.borderColor = UIColor.whiteColor().CGColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)

        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    
    }
}
