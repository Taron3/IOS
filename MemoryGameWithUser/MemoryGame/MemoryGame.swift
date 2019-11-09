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
    var isFaceUpTwoCards = false
    var isMatchedTwoCards = false
    
    var onlyOneFaceUpCardIndex: Int? {
        get {
            let faceUpCardIndices = cards.indices.filter { cards[$0].isFaceUp }
            return faceUpCardIndices.count == 1 ? faceUpCardIndices.first : nil
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (newValue == index)
            }
        }
    }
    
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
                if cards[matchIndex] == cards[index] {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    isMatchedTwoCards = true
                }
                cards[index].isFaceUp = true
                isFaceUpTwoCards = true
            } else {
                onlyOneFaceUpCardIndex = index
                isFaceUpTwoCards = false
            }
        }
    }
    
    
}
