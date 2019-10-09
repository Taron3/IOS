//
//  PlayingCardView.swift
//  PlayingCard
//
//  Created by 3 on 9/19/19.
//  Copyright © 2019 Taron. All rights reserved.
//

import UIKit

class PlayingCardView: UIView {
    var card = PlayingCard(rank: 7, suit: "♦️")! {
        didSet {
            setNeedsLayout()
            setNeedsDisplay()
        }
    }
    
    lazy var upperLeftLabel: UILabel = createLabel()
    lazy var lowerRightLabel: UILabel = createLabel()
    
    var isFaceUp = false {
        didSet {
            setNeedsLayout()
            setNeedsDisplay()
        }
    }
    
    // for pinch
    var faceCardScale: CGFloat = SizeRatio.faceCardImageSizeToBoundsSize {
        didSet {
            setNeedsLayout()
            setNeedsDisplay()
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setNeedsLayout()
        setNeedsDisplay()
    }
    
    func createLabel() -> UILabel {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        addSubview(lbl)
        
        return lbl
    }
    
    func centeredAttributedString(_ text: String, fontSize: CGFloat) -> NSAttributedString {
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        
        var font = UIFont.preferredFont(forTextStyle: .body).withSize(fontSize)
        font = UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
        
        return NSAttributedString(string: text, attributes: [NSAttributedString.Key.paragraphStyle: paragraph, .font: font])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let attributesString = centeredAttributedString(card.description, fontSize: cornerFontSize)
        
        upperLeftLabel.attributedText = attributesString
        upperLeftLabel.frame = CGRect.zero
        upperLeftLabel.sizeToFit()
        upperLeftLabel.frame.origin = bounds.origin.offsetBy(dx: cornerOffset, dy: cornerOffset)
        upperLeftLabel.isHidden = !isFaceUp
        
        lowerRightLabel.attributedText = attributesString
        lowerRightLabel.frame = CGRect.zero
        lowerRightLabel.sizeToFit()
        lowerRightLabel.frame.origin = CGPoint(x: bounds.maxX, y: bounds.maxY)
                                        .offsetBy(dx: -cornerOffset, dy: -cornerOffset)
                                        .offsetBy(dx: -lowerRightLabel.frame.width, dy: -lowerRightLabel.frame.height)
        lowerRightLabel.transform = CGAffineTransform.identity.rotated(by: CGFloat.pi)
        lowerRightLabel.isHidden = !isFaceUp
    }
    
    
    func drawPip(pipString: NSAttributedString,
                 offset: (center: CGFloat, vertical: CGFloat, horizontal: CGFloat),
                 position: (v: PipPosition.Vertical, h: PipPosition.Horizontal)) {
        
        switch position {
        case (.top, .center):
            pipString.draw(at: CGPoint(x: bounds.midX - offset.center, y: bounds.midY - 2 * offset.vertical - offset.center)) // topCenter
        case (.midTop, .center):
            pipString.draw(at: CGPoint(x: bounds.midX - offset.center, y: bounds.midY - offset.vertical - offset.center)) // center midTop
        case (.center, .center):
            pipString.draw(at: CGPoint(x: bounds.midX - offset.center, y: bounds.midY - offset.center)) // center
        case (.midBottom, .center):
            pipString.draw(at: CGPoint(x: bounds.midX - offset.center, y: bounds.midY + offset.vertical - offset.center)) // center midBottom
        case (.bottom, .center):
            pipString.draw(at: CGPoint(x: bounds.midX - offset.center, y: bounds.midY + 2 * offset.vertical - offset.center)) // bottomCenter
        case (.top, _):
            pipString.draw(at: CGPoint(x: bounds.midX - offset.horizontal - offset.center, y: bounds.midY - 2 * offset.vertical - offset.center)) // topLeft
            pipString.draw(at: CGPoint(x: bounds.midX + offset.horizontal - offset.center, y: bounds.midY - 2 * offset.vertical - offset.center)) // topRight
        case (.midTop, _):
            pipString.draw(at: CGPoint(x: bounds.midX - offset.horizontal - offset.center, y: bounds.midY - offset.vertical / 2 - offset.center)) // upLeft
            pipString.draw(at: CGPoint(x: bounds.midX + offset.horizontal - offset.center, y: bounds.midY - offset.vertical / 2 - offset.center)) // upRight
        case (.center, _):
            pipString.draw(at: CGPoint(x: bounds.midX - offset.horizontal - offset.center, y: bounds.midY - offset.center)) // leftCenter
            pipString.draw(at: CGPoint(x: bounds.midX + offset.horizontal - offset.center, y: bounds.midY - offset.center)) // rightCenter
        case (.midBottom, _):
            pipString.draw(at: CGPoint(x: bounds.midX - offset.horizontal - offset.center, y: bounds.midY + offset.vertical / 2 - offset.center)) // downLeft
            pipString.draw(at: CGPoint(x: bounds.midX + offset.horizontal - offset.center, y: bounds.midY + offset.vertical / 2 - offset.center)) // downRight
        case (.bottom, _):
            pipString.draw(at: CGPoint(x: bounds.midX - offset.horizontal - offset.center, y: bounds.midY + 2 * offset.vertical - offset.center)) // bottomLeft
            pipString.draw(at: CGPoint(x: bounds.midX + offset.horizontal - offset.center, y: bounds.midY + 2 * offset.vertical - offset.center)) // bottomRight
        }
    }
    
    func drawPips() {
        let rank = card.order

        // MARK: fontSize
        let pipString = centeredAttributedString(card.suit, fontSize: cornerFontSize)

        let factors = (center: cornerFontSize / 2,
                       vertical: bounds.height / 6,
                       horizontal: bounds.width / 4.5)
        
        let positions = PipPosition.positions(from: rank)
        
        positions.forEach { self.drawPip(pipString: pipString, offset: factors, position: $0) }
    }
    
    override func draw(_ rect: CGRect) {
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        roundedRect.addClip()
        UIColor.white.setFill()
        UIColor.lightGray.setStroke()
        roundedRect.fill()
        roundedRect.stroke()
        
        if isFaceUp {
            if let faceImg = UIImage(named: card.rank + card.suit) {
                faceImg.draw(in: bounds.zoom(by: faceCardScale)) // for pinch
            } else {
                drawPips()
            }
        } else if let backImage = UIImage(named: "back") {
            //if let backImage = UIImage(named: "back") {
            backImage.draw(in: bounds)
        }
    }
    
    
}



extension PlayingCardView {
    
    /// Ratios that determine the card's size
    struct SizeRatio {
        static let cornerFontSizeToBoundsHeight: CGFloat = 0.085
        static let cornerRadiusToBoundsHeight: CGFloat = 0.06
        static let cornerOffsetToCornerRadius: CGFloat = 0.33
        static let faceCardImageSizeToBoundsSize: CGFloat = 0.95  // for pinch
    }
    
    var cornerRadius: CGFloat {
        return bounds.size.height * SizeRatio.cornerRadiusToBoundsHeight
    }
    
    var cornerOffset: CGFloat {
        return cornerRadius * SizeRatio.cornerOffsetToCornerRadius
    }
    
    var cornerFontSize: CGFloat {
        return bounds.size.height * SizeRatio.cornerFontSizeToBoundsHeight
    }

    
}



extension CGPoint {

    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
        return CGPoint(x: x + dx, y: y + dy)
    }
}

// for pinch
extension CGRect {
    
    // Zoom rect by given factor
    func zoom(by zoomFactor: CGFloat) -> CGRect {
        let zoomedWidth = size.width * zoomFactor
        let zoomedHeight = size.height * zoomFactor
        let originX = origin.x + (size.width - zoomedWidth) / 2
        let originY = origin.y + (size.height - zoomedHeight) / 2
        return CGRect(origin: CGPoint(x: originX,y: originY) , size: CGSize(width: zoomedWidth, height: zoomedHeight))
    }
    
    
}

