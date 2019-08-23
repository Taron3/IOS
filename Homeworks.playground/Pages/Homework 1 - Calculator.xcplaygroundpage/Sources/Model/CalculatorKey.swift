//
//  CalculatorKey.swift
//  LSCalc
//
//  Created by David Shakhbazyan on 6/1/19.
//  Copyright © 2019 David Shakhbazyan. All rights reserved.
//

import Foundation

public enum CalculatorKey: RawRepresentable {
    case number(_ value: Int)
    case clear
    case toggleSign
    case percent
    case add
    case subtract
    case multiply
    case divide
    case dot
    case equal
    case undefined
    
    public typealias RawValue = String
    
    public var rawValue: RawValue {
        switch self {
        case .number(let x):    return String(x)
        case .clear:            return "C"
        case .toggleSign:       return "+/-"
        case .percent:          return "%"
        case .add:              return "+"
        case .subtract:         return "-"
        case .multiply:         return "×"
        case .divide:           return "÷"
        case .dot:              return "."
        case .equal:            return "="
        case .undefined:        return ""
        }
    }
    
    public init?(rawValue: RawValue) {
        switch rawValue {
        case CalculatorKey.clear.rawValue:      self = .clear
        case CalculatorKey.toggleSign.rawValue: self = .toggleSign
        case CalculatorKey.percent.rawValue:    self = .percent
        case CalculatorKey.add.rawValue:        self = .add
        case CalculatorKey.subtract.rawValue:   self = .subtract
        case CalculatorKey.multiply.rawValue:   self = .multiply
        case CalculatorKey.divide.rawValue:     self = .divide
        case CalculatorKey.dot.rawValue:        self = .dot
        case CalculatorKey.equal.rawValue:      self = .equal
        case CalculatorKey.undefined.rawValue:  self = .undefined
        default:
            if let x = Int(rawValue) {
                self = .number(x)
            } else {
                return nil
            }
        }
    }
}
