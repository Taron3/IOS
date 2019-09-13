//
//  MemoryGame.swift
//  MemoryGame
//
//  Created by 3 on 9/10/19.
//  Copyright © 2019 Taron. All rights reserved.
//

import Foundation

class MemoryGame {
    var cards = [Card]()
    
    var onlyOneFaceUpCardIndex: Int?
    
    var isFaceUpTwoCards = false
    var isMatchedTwoCards = false
    
    init(numberOfPairsOfCards: Int) {
        for _ in 0..<numberOfPairsOfCards {
            let card = Card()
            
            cards.append(card)
            cards.append(card)
        }
        cards.shuffle()
    }
    
    func chooseCard(at index: Int) {
        if !cards[index].isMatched {
            isMatchedTwoCards = false
            if let matchIndex = onlyOneFaceUpCardIndex, matchIndex != index {
                if cards[matchIndex].identifier == cards[index].identifier {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    isMatchedTwoCards = true
                }
                cards[index].isFaceUp = true
                onlyOneFaceUpCardIndex = nil
                isFaceUpTwoCards = true
            } else {
                for flipDownIndex in cards.indices {
                    cards[flipDownIndex].isFaceUp = false
                }
                cards[index].isFaceUp = true
                onlyOneFaceUpCardIndex = index
                isFaceUpTwoCards = false
            }
        }
    }
}
