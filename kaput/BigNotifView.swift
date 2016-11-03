//
//  BigNotifView.swift
//  kaput
//
//  Created by Jeremy OUANOUNOU on 09/06/2016.
//  Copyright © 2016 OPE50. All rights reserved.
//

import UIKit

var notifLenght = Int()
class BigNotifView: SpringView {
    
    
    override func draw(_ rect: CGRect) {
        let lenght = CGFloat(notifLenght)/100 * (self.bounds.width-26)
        
        var notifColor = KaputStyle.lowRed
        
        switch notifLenght{
        case 0...5:
            notifColor = KaputStyle.kaputBlack
            
        case 6...20:
            notifColor = KaputStyle.lowRed
           
        case 21...40:
            notifColor = KaputStyle.bloodyOrange
           
        case 41...80:
            notifColor = KaputStyle.midYellow
            
        case 81...100:
            notifColor = KaputStyle.fullGreen
            
        default :
            notifColor = KaputStyle.lowRed
            
        }

        print(notifColor)
        
        KaputStyle.drawBigNotif(frame: self.bounds, notifColor: notifColor,batteryLevelLenght:lenght)
        
    }


}
