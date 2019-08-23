import PlaygroundSupport
import UIKit

public class Controller: NSObject, CalculatorViewDelegate, CalculatorViewDataSource {
    var displayText = "0"
    var leftValue: Double?
    var rightValue: Double?
    var getOperator = ""
    var isOperatorPressed = false
    var isEqualPressed = false
    var isOperatorPressedAfterOperator = false
    var isDotPressed = false
    
    public func calculatorView(_ calculatorView: CalculatorView, didPress key: CalculatorKey) {
        switch key {
        case .clear:
            displayText = "0"
            leftValue = 0
            rightValue = 0
            getOperator = ""
            isOperatorPressed = false
            isEqualPressed = false
            isOperatorPressedAfterOperator = false
            isDotPressed = false
            
        case .toggleSign:
            if displayText == "0" {
                break
            }
            if displayText.first == "-" {
                displayText.removeFirst()
            } else {
                displayText = "-" + displayText
            }
            
        case .percent:
            if displayText == "0" {
                break
            }
            if let percentValue = Double(displayText) {
                displayText = String(percentValue / 100)
            }
            
        case .add,
             .subtract,
             .multiply,
             .divide :
            isOperatorPressed = true
            isEqualPressed = false
            if !isOperatorPressedAfterOperator {
                leftValue = Double(displayText)
            }
            if isOperatorPressedAfterOperator {
                rightValue = Double(displayText)
                leftValue = evaluate()
                isOperatorPressedAfterOperator = false
            }
            getOperator = key.rawValue
            
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
            leftValue = evaluate()
 
        default:
            if isOperatorPressed == true {
                isOperatorPressed = false
                isOperatorPressedAfterOperator = true
                displayText = "0"
            }
            if displayText == "0" {
                displayText = key.rawValue
            } else {
                displayText += key.rawValue
            }
        }
    }

    public func evaluate() -> Double {
        var result: Double = 0
        switch getOperator {
        case "+":
            result = leftValue! + rightValue!
        case "-":
            result = leftValue! - rightValue!
        case "×":
            result = leftValue! * rightValue!
        case "÷":
            result = leftValue! / rightValue!
        default:
            break
        }
        displayText = String(result)
        
        if displayText.hasSuffix(".0") {
            displayText.removeLast()
            displayText.removeLast()
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


