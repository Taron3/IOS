//
//  PlayingCard.swift
//  PlayingCard
//
//  Created by 3 on 9/18/19.
//  Copyright © 2019 Taron. All rights reserved.
//

import Foundation

extension PlayingCard {
    struct Deck {
        var cards = PlayingCard.allCases
        
        mutating func takeRandomCard() -> PlayingCard? {
            if cards.count > 0 {
                return cards.remove(at: Int.random(in: 0..<cards.count))
            } else {
                return nil
            }
        }
    }
}

enum PlayingCard: CaseIterable, CustomStringConvertible, Equatable {
    
    case numeric(Int, String)
    case face(String, String)
    
    init?(rank: Int, suit: String) {
        switch rank {
        case 2...10:
            self = .numeric(rank, suit)
        default:
            return nil
        }
    }
    
    init?(rank: String, suit: String) {
        switch rank {
        case "J", "Q", "K", "A":
            self = .face(rank, suit)
        default:
            return nil
        }
    }
    
    var suit: String {
        switch self {
        case .numeric(_, let suit):
            return suit
        case .face(_, let suit):
            return suit
        }
    }
    
    var rank: String {
        switch self {
        case .numeric(let rank, _):
            return String(rank)
        case .face(let rank, _):
            return rank
        }
    }
    
    var order: Int {
        switch self {
        case .numeric(let rank, _):
            return rank
        case .face(let rank, _) where rank == "J":
            return 11
        case .face(let rank, _) where rank == "Q":
            return 12
        case .face(let rank, _) where rank == "K":
            return 13
        case .face(let rank, _) where rank == "A":
            return 1
        default:
            return 0
        }
    }
    
    static var allCases: [PlayingCard] {
        var allCases = [PlayingCard]()
        for suit in ["♠️", "♥️", "♦️", "♣️"] {
            for rank in 2...10 {
                allCases.append(.numeric(rank, suit))
            }
            for rank in ["J", "Q", "K", "A"] {
                allCases.append(.face(rank, suit))
            }
        }
        return allCases
    }
    
    var description: String {
        switch self {
        case .numeric(let rank, let suit):
            return "\(rank)\n\(suit)"
        case .face(let rank, let suit):
            return "\(rank)\n\(suit)"
        }
    }
    
    static func ==(lhs: PlayingCard, rhs: PlayingCard) -> Bool {
        return lhs.rank == rhs.rank
            && lhs.suit == rhs.suit
    }
    
}




