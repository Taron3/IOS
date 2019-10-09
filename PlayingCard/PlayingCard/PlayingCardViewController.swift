//
//  ViewController.swift
//  PlayingCard
//
//  Created by 3 on 9/18/19.
//  Copyright © 2019 Taron. All rights reserved.
//

import UIKit

class PlayingCardViewController: UIViewController {
    
    @IBOutlet var playingCardViews: [PlayingCardView]!
    
    lazy var animator = UIDynamicAnimator(referenceView: view)
    
    lazy var cardBehavior = CardBehavior(in: animator)
    
    var deck = PlayingCard.Deck()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var cards = [PlayingCard]()
        for _ in 1...((playingCardViews.count + 1) / 2) {
            let card = deck.takeRandomCard()!
            cards += [card, card]
        }
        
        for cardView in playingCardViews {
            cardView.isFaceUp = false
            let card = cards.remove(at: Int.random(in: 0..<cards.count))
            cardView.card = card
            cardView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(flipCard(_:))))
            
            cardBehavior.addItem(cardView)
        }
    }
    
    var faceUpCardViews: [PlayingCardView] {
        return playingCardViews.filter { $0.isFaceUp
                                        && !$0.isHidden
                                        && $0.transform != CGAffineTransform.identity.scaledBy(x: 3.0, y: 3.0)
                                        && $0.alpha == 1
        }
    }
    
    var faceUpCardViewsMatch: Bool {
        return faceUpCardViews.count == 2
            && faceUpCardViews[0].card == faceUpCardViews[1].card
    }
   
    var lastChosenCardView: PlayingCardView?
    
    @objc func flipCard(_ recognizer: UITapGestureRecognizer) {
        switch recognizer.state {
        case .ended:
            if let chosenCardView = recognizer.view as? PlayingCardView, faceUpCardViews.count < 2 {
                lastChosenCardView = chosenCardView
                cardBehavior.removeItem(chosenCardView)
                UIView.transition(
                    with: chosenCardView,
                    duration: 0.7,
                    options: .transitionFlipFromLeft,
                    animations: { chosenCardView.isFaceUp = !chosenCardView.isFaceUp },
                    completion: { finished in
                        let cardsToAnimate = self.faceUpCardViews
                        if self.faceUpCardViewsMatch {
                            UIViewPropertyAnimator.runningPropertyAnimator(
                                withDuration: 0.7,
                                delay: 0,
                                options: [],
                                animations: { cardsToAnimate.forEach { $0.transform = CGAffineTransform.identity.scaledBy(x: 3.0, y: 3.0) } },
                                completion: { position in
                                    UIViewPropertyAnimator.runningPropertyAnimator(
                                        withDuration: 0.8,
                                        delay: 0,
                                        options: [],
                                        animations: { cardsToAnimate.forEach {
                                            $0.transform = CGAffineTransform.identity.scaledBy(x: 0.3, y: 0.3)
                                            $0.alpha = 0
                                            }
                                    },
                                        completion: { position in
                                            cardsToAnimate.forEach {
                                                $0.isHidden = true
                                                $0.alpha = 1
                                                $0.transform = .identity
                                            }
                                    })
                            } )
                        } else if cardsToAnimate.count == 2 {
                            if chosenCardView == self.lastChosenCardView {
                                cardsToAnimate.forEach { cardView in
                                    UIView.transition(
                                        with: cardView,
                                        duration: 0.7,
                                        options: .transitionFlipFromLeft,
                                        animations: { cardView.isFaceUp = false },
                                        completion: { finiched in
                                            self.cardBehavior.addItem(cardView)
                                    } )
                                }
                            }
                        } else {
                            if !chosenCardView.isFaceUp {
                                self.cardBehavior.addItem(chosenCardView)
                            }
                        }
                })
            }
        default:
            break
        }
    }



}

