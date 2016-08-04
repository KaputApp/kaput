//
//  downButton.swift
//  kaput
//
//  Created by Jeremy OUANOUNOU on 03/08/2016.
//  Copyright © 2016 OPE50. All rights reserved.
//
import UIKit

@IBDesignable

class downButton: SpringButton {
    
    override func drawRect(rect: CGRect) {
        KaputStyle.drawDownArrow()
        
    }
    
    

}

    