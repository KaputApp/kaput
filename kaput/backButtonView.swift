//
//  backButtonView.swift
//  kaput
//
//  Created by Jeremy OUANOUNOU on 01/06/2016.
//  Copyright © 2016 OPE50. All rights reserved.
//

import UIKit

@IBDesignable





class BackButtonView: UIButton {
    
    override func draw(_ rect: CGRect) {
        KaputStyle.drawBackArrow()
    }
    
    
}
