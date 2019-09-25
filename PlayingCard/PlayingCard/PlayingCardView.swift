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
    
    var isFlipped = false {
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
        
        let fontSize: CGFloat = 0.1 * self.bounds.width
        let attributesString = centeredAttributedString(card.description, fontSize: fontSize)
        
        let offset: CGFloat = 20
        upperLeftLabel.attributedText = attributesString
        upperLeftLabel.frame = CGRect.zero
        upperLeftLabel.sizeToFit()
        upperLeftLabel.frame = CGRect(x: offset, y: offset, width: upperLeftLabel.frame.width, height: upperLeftLabel.frame.height)
        upperLeftLabel.isHidden = isFlipped

        lowerRightLabel.attributedText = attributesString
        lowerRightLabel.frame = CGRect.zero
        lowerRightLabel.sizeToFit()
        lowerRightLabel.frame = CGRect(x: bounds.maxX - offset - lowerRightLabel.frame.width, y: bounds.maxY - offset - lowerRightLabel.frame.height, width: lowerRightLabel.frame.width, height: lowerRightLabel.frame.height)
        lowerRightLabel.transform = CGAffineTransform.identity.rotated(by: CGFloat.pi)
        lowerRightLabel.isHidden = isFlipped
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

        let fontSize: CGFloat = 0.2 * self.bounds.width
        let pipString = centeredAttributedString(card.suit, fontSize: fontSize)

        let factors = (center: fontSize / 2,
                       vertical: bounds.height / 6,
                       horizontal: bounds.width / 4.5)
        
        let positions = PipPosition.positions(from: rank)
        
        positions.forEach { self.drawPip(pipString: pipString, offset: factors, position: $0) }
    }
    
    override func draw(_ rect: CGRect) {
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: 20)
        roundedRect.addClip()
        UIColor.white.setFill()
        roundedRect.fill()
        
        if !isFlipped {
            if let faceImg = UIImage(named: card.rank + card.suit) {
                faceImg.draw(in: bounds)
            } else {
                drawPips()
            }
        } else {
            if let backImage = UIImage(named: "back") {
                backImage.draw(in: bounds)
            }
        }
    }
}
