//
//  Card.swift
//  MemoryGame
//
//  Created by 3 on 9/10/19.
//  Copyright © 2019 Taron. All rights reserved.
//

import Foundation

struct Card: Hashable {
    static var uniqueIdentifier = 0
    
    var isFaceUp = false
    var isMatched = false
    var identifier: Int
    
    
    init() {
        self.identifier = Card.generateUniqueIdentifier()
    }
    
    static func generateUniqueIdentifier() -> Int {
        uniqueIdentifier += 1
        return uniqueIdentifier
    }
    
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.identifier)
    }
    
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}
