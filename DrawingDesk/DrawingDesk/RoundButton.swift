//
//  RoundButton.swift
//  DrawingDesk
//
//  Created by 3 on 9/25/19.
//  Copyright © 2019 Taron. All rights reserved.
//

import UIKit

//@IBDesignable
class RoundButton: UIButton {
    
    @IBInspectable
    var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
 
}
