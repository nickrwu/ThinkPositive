//
//  PCButton.swift
//  EMDR
//
//  Created by Nick Wu on 1/1/18.
//  Copyright © 2018 Nick Wu. All rights reserved.
//

import UIKit

class PCButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func draw(_ rect: CGRect) {
        MyStyleKit.drawStartButton()
    }
}
