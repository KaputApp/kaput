//
//  PaddingLabel.swift
//  kaput
//
//  Created by Jeremy OUANOUNOU on 17/07/2016.
//  Copyright © 2016 OPE50. All rights reserved.
//

import UIKit

@IBDesignable class PaddingLabel: SpringLabel {
    
        @IBInspectable var topInset: CGFloat = 0
        @IBInspectable var bottomInset: CGFloat = 0
        @IBInspectable var leftInset: CGFloat = 0
        @IBInspectable var rightInset: CGFloat = 0
        
        override func drawTextInRect(rect: CGRect) {
            let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
            super.drawTextInRect(UIEdgeInsetsInsetRect(rect, insets))
        }
        
        override func intrinsicContentSize() -> CGSize {
            var intrinsicSuperViewContentSize = super.intrinsicContentSize()
            intrinsicSuperViewContentSize.height += topInset + bottomInset
            intrinsicSuperViewContentSize.width += leftInset + rightInset
            return intrinsicSuperViewContentSize
        }
    }
