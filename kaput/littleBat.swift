//
//  littleBat.swift
//  kaput
//
//  Created by Jeremy OUANOUNOU on 12/08/2016.
//  Copyright © 2016 OPE50. All rights reserved.
//


import UIKit

var batLenght = CGFloat()
class littleBat: SpringView {
    
    
    override func drawRect(rect: CGRect) {
        let lenght = CGFloat(batLenght)/100 * (self.bounds.width)
        
        KaputStyle.drawLittleBat(batteryLevelLenght: lenght)
    }
    
    
}
