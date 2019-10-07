//
//  PanViewController.swift
//  DrawingDesk
//
//  Created by 3 on 10/6/19.
//  Copyright © 2019 Taron. All rights reserved.
//

import UIKit

class PanViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    
    weak var panDataDelegate: PanDataDelegate?
    
    @IBAction func touchSizeButton(_ sender: UIButton) {
        panDataDelegate?.lineWidth(widthSize: sender.tag)
    }
    
    @IBAction func changeSlider(_ sender: UISlider) {
        panDataDelegate?.lineOpacity(opacitySize: sender.value)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }

}
