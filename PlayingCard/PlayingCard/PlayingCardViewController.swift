//
//  ViewController.swift
//  PlayingCard
//
//  Created by 3 on 9/18/19.
//  Copyright © 2019 Taron. All rights reserved.
//

import UIKit

class PlayingCardViewController: UIViewController {
    
    @IBOutlet weak var playingCardView: PlayingCardView! {
        didSet {
            let swipe = UISwipeGestureRecognizer(target: self, action: #selector(nextCard))
            swipe.direction = [.left, .right]
            playingCardView.addGestureRecognizer(swipe)
        }
    }
    
    var deck = PlayingCardDeck()
    
    @objc func nextCard() {
        if let card = deck.takeRandomCard() {
            playingCardView.card = card
        }
    }
    
    @IBAction func flipCard(_ sender: UITapGestureRecognizer) {
        switch sender.state {
        case .ended:
            playingCardView.isFlipped = !playingCardView.isFlipped
        default:
            break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }


}

