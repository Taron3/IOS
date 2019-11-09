//
//  User.swift
//  MemoryGame
//
//  Created by 3 on 11/8/19.
//  Copyright © 2019 Taron. All rights reserved.
//

import Foundation


class User: NSObject {
    var username: String
    @objc dynamic var score: Int
    
    static let shared = User(username: "username", score: 0)
    
    private init(username: String, score: Int) {
        self.username = username
        self.score = score
    }
    
    
}
