//
//  DrawingDeskView.swift
//  DrawingDesk
//
//  Created by 3 on 9/19/19.
//  Copyright © 2019 Taron. All rights reserved.
//


import UIKit

class ShapeLayer: CAShapeLayer {
    override func contains(_ p: CGPoint) -> Bool {
        guard let path = path?.copy(strokingWithWidth: max(lineWidth, 18),
                                    lineCap: .round,
                                    lineJoin: .round,
                                    miterLimit: .nan) else { return false }
        
        return path.contains(p)
    }

}

class DrawingDeskView: UIView {
    enum Mode {
        case draw
        case move
    }
    
    var mode: Mode = .draw
    
    var bezierPath = UIBezierPath()
    var drawColor = UIColor.black
    var lineWidth: CGFloat = 20
    var lineOpacity: Float = 0.8
    
    var selectedLayer: ShapeLayer?
    var drawingLayer: ShapeLayer!
    var maskDrawingImageView = UIImageView()
    
    var redoLayers = [CALayer]()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initSelf()
        
        initGestureRecognizer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    
        initSelf()
        
        initGestureRecognizer()
    }
    
    func initSelf() {
        self.clipsToBounds = true
        self.addSubview(maskDrawingImageView)
    }
    
    func initGestureRecognizer() {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(pan(recognizer:)))
        addGestureRecognizer(panGestureRecognizer)
        
        panGestureRecognizer.cancelsTouchesInView = false
    }
    
    func changeDrawColor(to color: UIColor) {
        self.drawColor = color
    }
    
    func changeLineWidth(to lineWidth: Int) {
        self.lineWidth = CGFloat(lineWidth)
    }
    
    func changeLineOpacity(to lineOpacity: Float) {
        self.lineOpacity = lineOpacity
    }
    
    func setupBezierPath() {
        bezierPath = UIBezierPath()
        bezierPath.lineWidth = lineWidth
        bezierPath.lineCapStyle = .round
        bezierPath.lineJoinStyle = .round
    }
    
    @objc func pan(recognizer: UIPanGestureRecognizer) {
        guard mode == .move else {
            return
        }
        
        switch recognizer.state {
        case .began:
            guard let sublayers = self.layer.sublayers,
                let _ = sublayers.last else {
                    return
            }
            
            self.layer.sublayers!.last!.isHidden = true
            
            let touchLocation = recognizer.location(in: self)
            selectLayer(at: touchLocation)
            
        case .changed:
            guard let layer = selectedLayer else {
                self.layer.sublayers!.last!.isHidden = false
                return
            }
            let translation = recognizer.translation(in: recognizer.view)
            
            CATransaction.begin()
            CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
            
            layer.position = CGPoint(x: layer.position.x + translation.x,
                                     y: layer.position.y + translation.y)
            
            //draw(bounds)
            recognizer.setTranslation(CGPoint.zero, in: self)
            
            CATransaction.commit()
            
        case .ended:
            guard let _ = selectedLayer,
                let sublayers = self.layer.sublayers,
                let _ = sublayers.last else {
                    return
            }
            
            selectedLayer!.zPosition = 0.0
            self.layer.sublayers!.last!.isHidden = false
            
        default:
            break
        }
    }
    
    
    private func selectLayer(at location: CGPoint) {
        let newLocation = self.layer.convert(location, to: self.layer.superlayer)
        let layer = self.layer.hitTest(newLocation)
        
        guard let shapeLayer = layer as? ShapeLayer else {
            selectedLayer = nil
            return
        }
        
        selectedLayer = shapeLayer
        shapeLayer.zPosition = 1.0
        
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard mode == .draw else {
            return
        }

        updateMaskDrawingImageView()
        setupBezierPath()
        redoLayers = []
        
        let touch = touches.first!
        bezierPath.move(to: touch.location(in: self))
        
        updateMaskDrawingImageView()
        setNeedsDisplay()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard  mode == .draw else {
            return
        }

        updateMaskDrawingImageView()
        
        let touch = touches.first!
        bezierPath.addLine(to: touch.location(in: self))
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard  mode == .draw else {
            return
        }

        let img = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        maskDrawingImageView.image = img
        
        convertPathToLayer()
        bringSubviewToFront(maskDrawingImageView)
        
        setNeedsDisplay()
    }
 
    
    func convertPathToLayer() {
        drawingLayer = ShapeLayer()
        drawingLayer.frame = bezierPath.bounds
        
        bezierPath.apply(CGAffineTransform(translationX: -bezierPath.bounds.origin.x,
                                           y: -bezierPath.bounds.origin.y))
        drawingLayer.path = bezierPath.cgPath
        drawingLayer.lineWidth = lineWidth
        drawingLayer.opacity = lineOpacity
        drawingLayer.lineCap = .round
        drawingLayer.lineJoin = .round
        drawingLayer.strokeColor = drawColor.cgColor
        drawingLayer.fillColor = nil

        layer.addSublayer(drawingLayer)
 
        setNeedsDisplay()
    }
    
    
    func updateMaskDrawingImageView() {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0)
        
        drawColor.setStroke()
        bezierPath.stroke(with: .normal, alpha: CGFloat(lineOpacity))
        
        let img = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        maskDrawingImageView.image = img
        maskDrawingImageView.frame = bounds
        
        setNeedsDisplay()
    }
    
    func undoStroke() {
        guard layer.sublayers != nil else {
            return
        }
        
        let lastIndex = layer.sublayers!.count - 1
        if lastIndex >= 1 {
            redoLayers.append(layer.sublayers!.remove(at: lastIndex - 1))
        }
        
    }
    
    func redoStroke() {
        guard layer.sublayers != nil else {
            return
        }
        
        let lastIndex = layer.sublayers!.count - 1
        if let lastLayer = redoLayers.popLast() {
            layer.insertSublayer(lastLayer, at: UInt32(lastIndex))
        }
    }
    
    
    
    /*
    override func draw(_ rect: CGRect) {

    }
*/
    
    
    
}
