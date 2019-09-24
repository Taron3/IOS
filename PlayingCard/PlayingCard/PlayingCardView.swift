//
//  PlayingCardView.swift
//  PlayingCard
//
//  Created by 3 on 9/19/19.
//  Copyright © 2019 Taron. All rights reserved.
//

import UIKit

class PlayingCardView: UIView {
    var card = PlayingCard(rank: 7, suit: "♥️")! {
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
    
    
    func drawCenter(pipString: NSAttributedString, _ upDownFactor: CGFloat, _ leftRightFactor: CGFloat, _ centerFactor: CGFloat) {
        let rank = card.order
        if rank % 2 != 0 && rank != 7 {
            pipString.draw(at: CGPoint(x: bounds.midX - centerFactor, y: bounds.midY - centerFactor)) // center
        } else if rank == 7 {
            pipString.draw(at: CGPoint( x: bounds.midX - centerFactor, y: bounds.midY - upDownFactor - centerFactor)) // upCenter
        }
    }
    
    func drawTopBottomCenter(pipString: NSAttributedString, _ upDownFactor: CGFloat, _ leftRightFactor: CGFloat, _ centerFactor: CGFloat) {
        pipString.draw(at: CGPoint(x: bounds.midX - centerFactor, y: bounds.midY - 2 * upDownFactor - centerFactor)) // topCenter
        pipString.draw(at: CGPoint(x: bounds.midX - centerFactor, y: bounds.midY + 2 * upDownFactor - centerFactor)) // bottomCenter
    }
    
    func drawCorner(pipString: NSAttributedString, _ upDownFactor: CGFloat, _ leftRightFactor: CGFloat, _ centerFactor: CGFloat) {
        pipString.draw(at: CGPoint(x: bounds.midX - leftRightFactor - centerFactor, y: bounds.midY - 2 * upDownFactor - centerFactor)) // topLeft
        pipString.draw(at: CGPoint(x: bounds.midX + leftRightFactor - centerFactor, y: bounds.midY - 2 * upDownFactor - centerFactor)) // topRight
        pipString.draw(at: CGPoint(x: bounds.midX - leftRightFactor - centerFactor, y: bounds.midY + 2 * upDownFactor - centerFactor)) // bottomLeft
        pipString.draw(at: CGPoint(x: bounds.midX + leftRightFactor - centerFactor, y: bounds.midY + 2 * upDownFactor - centerFactor)) // bottomRight
    }
    
    func drawLeftRightCenter(pipString: NSAttributedString, _ upDownFactor: CGFloat, _ leftRightFactor: CGFloat, _ centerFactor: CGFloat) {
        pipString.draw(at: CGPoint(x: bounds.midX - leftRightFactor - centerFactor, y: bounds.midY - centerFactor)) // leftCenter
        pipString.draw(at: CGPoint(x: bounds.midX + leftRightFactor - centerFactor, y: bounds.midY - centerFactor)) // rightCenter
    }
    
    func drawUpDownCorner(pipString: NSAttributedString, _ upDownFactor: CGFloat, _ leftRightFactor: CGFloat, _ centerFactor: CGFloat) {
        pipString.draw(at: CGPoint(x: bounds.midX - leftRightFactor - centerFactor, y: bounds.midY - upDownFactor / 2 - centerFactor)) // upLeft
        pipString.draw(at: CGPoint(x: bounds.midX + leftRightFactor - centerFactor, y: bounds.midY - upDownFactor / 2 - centerFactor)) // upRight
        pipString.draw(at: CGPoint(x: bounds.midX - leftRightFactor - centerFactor, y: bounds.midY + upDownFactor / 2 - centerFactor)) // downLeft
        pipString.draw(at: CGPoint(x: bounds.midX + leftRightFactor - centerFactor, y: bounds.midY + upDownFactor / 2 - centerFactor)) // downRight
    }
    
    func drawUpDownCenter(pipString: NSAttributedString, _ upDownFactor: CGFloat, _ leftRightFactor: CGFloat, _ centerFactor: CGFloat) {
        pipString.draw(at: CGPoint(x: bounds.midX - centerFactor, y: bounds.midY - upDownFactor - centerFactor)) // upCenter
        pipString.draw(at: CGPoint(x: bounds.midX - centerFactor, y: bounds.midY + upDownFactor - centerFactor)) // downCenter
    }
    
    func drawPips () {
        let rank = card.order

        let upDownFactor = bounds.height / 6
        let leftRightFactor = bounds.width / 4.5
        let fontSize: CGFloat = 0.2 * self.bounds.width
        let centerFactor = fontSize / 2
        let pipString = centeredAttributedString(card.suit, fontSize: fontSize)

        switch rank {
        case 2...3:
            drawTopBottomCenter(pipString: pipString, upDownFactor, leftRightFactor, centerFactor)
        case 4...10:
            drawCorner(pipString: pipString, upDownFactor, leftRightFactor, centerFactor)
            if (6...8).contains(rank) {
                drawLeftRightCenter(pipString: pipString, upDownFactor, leftRightFactor, centerFactor)
            }
            if (9...10).contains(rank) {
                drawUpDownCorner(pipString: pipString, upDownFactor, leftRightFactor, centerFactor)
            }
            if rank == 8 || rank == 10 {
                drawUpDownCenter(pipString: pipString, upDownFactor, leftRightFactor, centerFactor)
            }
        default:
            break
        }
        
        drawCenter(pipString: pipString, upDownFactor, leftRightFactor, centerFactor)
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
