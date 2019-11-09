//
//  UserProfileViewController.swift
//  MemoryGame
//
//  Created by 3 on 11/8/19.
//  Copyright © 2019 Taron. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController {
    @IBOutlet weak var scoreLabel: UILabel!
    
    var observed: NSKeyValueObservation!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        observed = User.shared.observe(\.score, options: .new) { [weak self] (user, change) in
            if let self = self, let newValue = change.newValue {
                self.scoreLabel.text = "Score: \(newValue)"
            }
        }
        
    }

    
}
