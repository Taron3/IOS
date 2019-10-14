//
//  DrawingDeskView.swift
//  DrawingDesk
//
//  Created by 3 on 9/19/19.
//  Copyright © 2019 Taron. All rights reserved.
//


import UIKit

class ShapeLayer: CAShapeLayer {

    var identifier = ShapeLayer.generateUniqueIdentifier()
    
    static var uniqueIdentifier = 0

    static func generateUniqueIdentifier() -> Int {
        uniqueIdentifier += 1
        return uniqueIdentifier
    }
    
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
    
    enum Action {
        case draw(Int)
        case move(Int, CGPoint)
        
    }
    
    var mode: Mode = .draw
    
    var bezierPath = UIBezierPath()
    var drawColor = UIColor.black
    var lineWidth: CGFloat = 20
    var lineOpacity: Float = 0.8
    
    var selectedLayer: ShapeLayer?
    var drawingLayer: ShapeLayer!
    var maskDrawingImageView = UIImageView()
    
    var undoActions = Stack<Action>()
    var redoActions = Stack<Action>()
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
    
    // MARK: - Moving
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
            
            guard let layer = selectedLayer else {
                return
            }
            undoActions.push(.move(layer.identifier, touchLocation))
            
            redoActions = Stack<Action>()
            redoLayers = []
            
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
    
    
    // MARK: Drawing
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard mode == .draw else {
            return
        }

        updateMaskDrawingImageView()
        setupBezierPath()
        redoActions = Stack<Action>()
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
        undoActions.push(.draw(drawingLayer.identifier))
 
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
    
    // MARK: - Undo, Redo Manager

    func getActiveLayer(for identifier: Int) -> CALayer? {
        guard layer.sublayers != nil else {
            preconditionFailure("Sublayers is nil")
        }
        
        let activeLayer = self.layer.sublayers!.first { layer in
            guard let shapeLayer = layer as? ShapeLayer else {
                preconditionFailure("Layer of type: \(type(of: layer))")
            }
            return shapeLayer.identifier == identifier
        }
        
        return activeLayer
    }
    

    func undoManager() {
        guard !undoActions.isEmpty else {
            return
        }
        
        let lastAction = undoActions.pop()
        
        switch lastAction {
        case let .move(layerIdentifier, position):
            undoMovedStroke(for: layerIdentifier, to: position)
            
        case .draw(let layerIdentifier):
            undoStroke(for: layerIdentifier)
        }

    }
    
    
    func undoStroke(for layerIdentifier: Int) {
        if let drawedLayer = getActiveLayer(for: layerIdentifier) {
            redoActions.push(.draw(layerIdentifier))
            redoLayers.append(drawedLayer)
            
            drawedLayer.removeFromSuperlayer()
        }
    }
    
    func undoMovedStroke(for layerIdentifier: Int, to position: CGPoint) {
        if let movedLayer = getActiveLayer(for: layerIdentifier) {
            redoActions.push(.move(layerIdentifier, movedLayer.position))
            movedLayer.position = position
        }
        
    }
    
    func redoManager() {
        guard !redoActions.isEmpty else {
            return
        }
        
        let lastAction = redoActions.pop()
        
        switch lastAction {
        case let .move(layerIdentifier, position):
            redoMovedStroke(for: layerIdentifier, to: position)
            
        case .draw(let layerIdentifier):
            redoStroke(for: layerIdentifier)
            
        }
    }
    
    func redoMovedStroke(for layerIdentifier: Int, to position: CGPoint) {
         if let movedLayer = getActiveLayer(for: layerIdentifier) {
             undoActions.push(.move(layerIdentifier, movedLayer.position))
             movedLayer.position = position
         }
    }
    
    func redoStroke(for layerIdentifier: Int) {
        guard layer.sublayers != nil else {
            return
        }
        
        undoActions.push(.draw(layerIdentifier))
        
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
