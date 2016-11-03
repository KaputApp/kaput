
//
//  File.swift
//  kaput
//
//  Created by Jeremy OUANOUNOU on 20/08/2016.
//  Copyright © 2016 OPE50. All rights reserved.
//

import UIKit

extension UIImage{
    
    func alpha(_ value:CGFloat)->UIImage
    {
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0.0)
        
        let ctx = UIGraphicsGetCurrentContext();
        let area = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height);
        
        ctx!.scaleBy(x: 1, y: -1);
        ctx!.translateBy(x: 0, y: -area.size.height);
        ctx!.setBlendMode(CGBlendMode.multiply);
        ctx!.setAlpha(value);
        ctx!.draw(self.cgImage!, in: area);
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return newImage!;
    }
}
