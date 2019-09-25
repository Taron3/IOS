//
//  PipPosition.swift
//  PlayingCard
//
//  Created by 3 on 9/24/19.
//  Copyright © 2019 Taron. All rights reserved.
//

enum PipPosition {
    enum Vertical: Int {
        case top
        case midTop
        case center
        case midBottom
        case bottom
    }
    
    enum Horizontal: Int {
        case left, center, right
    }
    
    static func positions(from rank: Int) -> [(Vertical, Horizontal)] {
        let mask = positionMask(from: rank)
        assert(mask.count == 15, "Mask should contain exactly 15 elements")
        
        return mask.enumerated().compactMap { offset, element in
            guard element == 1 else {
                return nil
            }
            let v = Vertical(rawValue: offset / 3)!
            let h = Horizontal(rawValue: offset - v.rawValue * 3)!
            
            return (v, h)
        }
    }
    
    private static func positionMask(from rank: Int) -> [Int] {
        switch rank {
        case 2:
            return [0, 1, 0,
                    0, 0, 0,
                    0, 0, 0,
                    0, 0, 0,
                    0, 1, 0]
        case 3:
            return [0, 1, 0,
                    0, 0, 0,
                    0, 1, 0,
                    0, 0, 0,
                    0, 1, 0]
        case 4:
            return [1, 0, 1,
                    0, 0, 0,
                    0, 0, 0,
                    0, 0, 0,
                    1, 0, 1]
        case 5:
            return [1, 0, 1,
                    0, 0, 0,
                    0, 1, 0,
                    0, 0, 0,
                    1, 0, 1]
        case 6:
            return [1, 0, 1,
                    0, 0, 0,
                    1, 0, 1,
                    0, 0, 0,
                    1, 0, 1]
        case 7:
            return [1, 0, 1,
                    0, 1, 0,
                    1, 0, 1,
                    0, 0, 0,
                    1, 0, 1]
        case 8:
            return [1, 0, 1,
                    0, 1, 0,
                    1, 0, 1,
                    0, 1, 0,
                    1, 0, 1]
        case 9:
            return [1, 0, 1,
                    1, 0, 1,
                    0, 1, 0,
                    1, 0, 1,
                    1, 0, 1]
        case 10:
            return [1, 0, 1,
                    1, 1, 1,
                    0, 0, 0,
                    1, 1, 1,
                    1, 0, 1]
        default:
            break
        }
        preconditionFailure("Unknown Rank: \(rank)")
    }
}
