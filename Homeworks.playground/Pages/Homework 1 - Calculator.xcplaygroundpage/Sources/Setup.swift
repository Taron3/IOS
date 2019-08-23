import PlaygroundSupport
import UIKit

public func setupCalculatorView(for page: PlaygroundPage, with controller: CalculatorViewDelegate & CalculatorViewDataSource) {
    // Setup the calculator view
    let view = CalculatorView()
    view.bounds = CGRect(origin: .zero, size: CGSize.iPhone.xs)
    page.liveView = view
    
    view.delegate = controller
    view.dataSource = controller
}
