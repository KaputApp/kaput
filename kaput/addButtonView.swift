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
    
    override func drawRect(rect: CGRect) {
        KaputStyle.drawAddButton()
        
    }
    
}
