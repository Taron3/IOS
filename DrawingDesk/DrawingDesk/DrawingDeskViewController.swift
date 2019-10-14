//
//  ViewController.swift
//  DrawingDesk
//
//  Created by 3 on 9/19/19.
//  Copyright © 2019 Taron. All rights reserved.
//

import UIKit

class DrawingDeskViewController: UIViewController {
    
    @IBOutlet weak var drawingDeskView: DrawingDeskView!
    
    @IBAction func colorButton(_ sender: UIButton) {
        drawingDeskView.changeDrawColor(to: sender.currentTitleColor) 
    }
     
    @IBAction func panButton(_ sender: Any) {
        self.performSegue(withIdentifier: "Pan", sender: self)
    }
    
    func changeLineWidth(to lineWidth: Int) {
        drawingDeskView.changeLineWidth(to: lineWidth)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Pan" {
            let destination = segue.destination
            
            if let popUpPC = destination.popoverPresentationController,
                let panVC = destination as? PanViewController {
                popUpPC.delegate = panVC
                panVC.panDataDelegate = self
            }
        }
        
    }
 
    @IBAction func undoButton(_ sender: UIButton) {
        drawingDeskView.undoManager()
    }
    
    
    @IBAction func redoButton(_ sender: UIButton) {
        drawingDeskView.redoManager()
    }
    
    @IBAction func changeMode(_ sender: UISegmentedControl) {
        drawingDeskView.mode = sender.selectedSegmentIndex == 0 ? .draw : .move
    }


}



protocol PanDataDelegate: class {
    func lineWidth(widthSize: Int)
    func lineOpacity(opacitySize: Float)
}



extension DrawingDeskViewController: PanDataDelegate {
    func lineWidth(widthSize: Int) {
        drawingDeskView.changeLineWidth(to: widthSize)
    }
    
    func lineOpacity(opacitySize: Float) {
        drawingDeskView.changeLineOpacity(to: opacitySize)
    }
    
    
}


