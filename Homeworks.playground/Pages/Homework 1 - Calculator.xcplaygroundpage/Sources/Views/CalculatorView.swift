//
//  CalculatorView.swift
//  LSCalc
//
//  Created by David Shakhbazyan on 6/1/19.
//  Copyright © 2019 David Shakhbazyan. All rights reserved.
//

import UIKit

/// - Tag: CalculatorView-delegate
public protocol CalculatorViewDelegate: class {
    func calculatorView(_ calculatorView: CalculatorView, didPress key: CalculatorKey)
}

/// - Tag: CalculatorView-dataSource
public protocol CalculatorViewDataSource: class {
    func displayText(_ calculatorView: CalculatorView) -> String
}

/// - Tag: CalculatorView
public class CalculatorView: UIView {
    public weak var delegate: CalculatorViewDelegate?
    
    public weak var dataSource: CalculatorViewDataSource?
    
    @IBOutlet private var display: UILabel!
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let view = loadFromNib()
        view.frame = bounds
        self.addSubview(view)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let view = loadFromNib()
        view.frame = bounds
        self.addSubview(view)
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    // MARK: - Private Interface
    
    private func loadFromNib() -> UIView {
        guard
            let nib = type(of: self).loadNib(owner: self, options: nil),
            let view = nib.first as? UIView
        else {
            preconditionFailure("Couldn't load \(self) from nib")
        }
        return view
    }
    
    @IBAction func handleKeyPress(_ sender: UIButton) {
        guard
            let text = sender.titleLabel?.text,
            let key = CalculatorKey(rawValue: text)
            else {
                fatalError("Found an undefined key in \(self)")
        }
        delegate?.calculatorView(self, didPress: key)
        display.text = dataSource?.displayText(self)
    }
}
