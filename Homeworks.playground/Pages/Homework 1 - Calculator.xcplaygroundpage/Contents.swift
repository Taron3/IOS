
import PlaygroundSupport
import UIKit

enum ArithmeticOperator {
    case addition
    case subtraction
    case multiplication
    case division
    
    var function: (Double, Double) -> Double {
        switch self {
        case .addition: return { $0 + $1 }
        case .subtraction: return { $0 - $1 }
        case .multiplication: return { $0 * $1 }
        case .division: return { $0 / $1 }
        }
    }
    
    init?(_ calculatorKey: CalculatorKey) {
        switch calculatorKey {
        case .add:
            self = .addition
        case .subtract:
            self = .subtraction
        case .multiply:
            self = .multiplication
        case .divide:
            self = .division
        default:
            return nil
        }
    }
}

//enum ControllerError: Error {
//    case invalidDisplaytext
//    case invalidValue
//}

class Controller: NSObject, CalculatorViewDelegate, CalculatorViewDataSource {
    
    var displayText = "0"
    var leftValue: Double?
    var rightValue: Double?
    var arithmeticOperator: ArithmeticOperator?
    var isOperatorPressed = false
    var isEqualPressed = false
    var isOperatorPressedAfterOperator = false
    var isDotPressed = false
    
    
    public func calculatorView(_ calculatorView: CalculatorView, didPress key: CalculatorKey) /* throws */ {
        switch key {
        case .clear:
            displayText = "0"
            leftValue = nil
            rightValue = nil
            arithmeticOperator = nil
            isOperatorPressed = false
            isEqualPressed = false
            isOperatorPressedAfterOperator = false
            isDotPressed = false
        case .toggleSign:
            if displayText == "0" {
                break
            }
            
            displayText.first == "-" ? (_ = displayText.removeFirst()) : (displayText = "-" + displayText)
        case .percent:
            if displayText == "0" {
                break
            }
            guard let percentValue = Double(displayText) else {
//                throw ControllerError.invalidDisplaytext
                fatalError()
            }
            displayText = String(percentValue / 100)
            
        case .add, .subtract, .multiply, .divide:
            isOperatorPressed = true
            isEqualPressed = false
            if !isOperatorPressedAfterOperator {
                leftValue = Double(displayText)
            }
            if isOperatorPressedAfterOperator {
                rightValue = Double(displayText)
//                do {
                    leftValue = /* try */ evaluate()
//                } catch ControllerError.invalidValue {
//                    print("Invalid Value")
//                }
//                do {
                    leftValue = /* try */ evaluate()
//                } catch ControllerError.invalidValue {
//                    print("Invalid Value")
//                }
                isOperatorPressedAfterOperator = false
            }
            arithmeticOperator = ArithmeticOperator(key)
        case .dot:
            if !isDotPressed {
                displayText += "."
                isDotPressed = true
            }
        case .equal:
            if !isEqualPressed {
                rightValue = Double(displayText)
            }
            isEqualPressed = true
//            do {
                leftValue = /* try */ evaluate()
//            } catch ControllerError.invalidValue {
//                print("Invalid Value")
//            }
        default:
            if isOperatorPressed == true {
                isOperatorPressed = false
                isOperatorPressedAfterOperator = true
                displayText = "0"
            }
            
            displayText == "0" ? (displayText = key.rawValue) : (displayText += key.rawValue)
        }
    }

    public func evaluate() /*t hrows */ -> Double {
        guard
            let leftValue = leftValue,
            let rightValue = rightValue,
            let function = arithmeticOperator?.function else {
            fatalError()
//            throw ControllerError.invalidValue
        }
        
        let result = function(leftValue, rightValue)
        displayText = String(result)
        
        if displayText.hasSuffix(".0") {
            displayText = String(displayText.dropLast(2))
        }
    
        return result
    }

    public func displayText(_ calculatorView: CalculatorView) -> String {
        return displayText
    }
}


// Internal Setup
let controller = Controller(), page = PlaygroundPage.current
setupCalculatorView(for: page, with: controller)

// To see the calculator view:
// 1. Run the Playground (⌘Cmd + ⇧Shift + ↩Return)
// 2. View Assistant Editors (⌘Cmd + ⌥Opt + ↩Return)
// 3. Select Live View in the Assistant Editor tabs

