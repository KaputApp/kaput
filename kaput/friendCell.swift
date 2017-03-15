//
//  friendCell.swift
//  kaput
//
//  Created by Jeremy OUANOUNOU on 30/12/2016.
//  Copyright © 2016 OPE50. All rights reserved.
//

import UIKit
import MGSwipeTableCell

class friendCell: MGSwipeTableCell {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBOutlet var friendsName: UILabel!
    @IBOutlet var friendsBat: UILabel!
}
