//
//  Stack.swift
//  DrawingDesk
//
//  Created by 3 on 10/12/19.
//  Copyright © 2019 Taron. All rights reserved.
//

import Foundation

struct Stack<Element> {
    private var items = [Element]()
    
    mutating func push(_ item: Element) {
        items.append(item)
    }
    
    mutating func pop() -> Element {
        guard !items.isEmpty else {
            preconditionFailure("Stack is empty")
        }
        
        return items.removeLast()
    }
    
    var topItem: Element? {
        //return items.isEmpty ? nil : items[items.count - 1]
        return items.last
    }
    
    var isEmpty: Bool {
        return items.isEmpty
    }
    
    var size: Int {
        return items.count
    }
}
