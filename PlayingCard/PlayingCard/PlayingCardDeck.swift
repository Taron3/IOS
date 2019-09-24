//
//  PlayingCardDeck.swift
//  PlayingCard
//
//  Created by 3 on 9/18/19.
//  Copyright © 2019 Taron. All rights reserved.
//

import Foundation

struct PlayingCardDeck {    
    var cards = PlayingCard.allCases
    
    mutating func takeRandomCard() -> PlayingCard? {
        if cards.count > 0 {
            return cards.remove(at: Int.random(in: 0..<cards.count))
        } else {
            return nil
        }
    }
    
}


