//
//  UIView+Nib.swift
//  LSCalc
//
//  Created by David Shakhbazyan on 6/1/19.
//  Copyright © 2019 David Shakhbazyan. All rights reserved.
//

import UIKit

extension UIView {
    class var nibName: String {
        return "\(self)".components(separatedBy: ".").first ?? ""
    }
    
    class var nib: UINib {
        let bundle = Bundle(for: self)
        return UINib(nibName: nibName, bundle: bundle)
    }
    
    class func loadNib(owner: Any?, options: [UINib.OptionsKey : Any]?) -> [Any]? {
        let bundle = Bundle(for: self)
        return bundle.loadNibNamed(nibName, owner: owner, options: options)
    }
}
