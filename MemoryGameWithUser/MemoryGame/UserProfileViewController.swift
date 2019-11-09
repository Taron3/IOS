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

    @IBAction func startGameButton(_ sender: UIButton) {
        let memoryGameThemeChooserVC = storyboard?.instantiateViewController(identifier: "MemoryGameThemeChooserViewController") as! MemoryGameThemeChooserViewController
        navigationController?.pushViewController(memoryGameThemeChooserVC, animated: true)
    }
    
    @IBAction func moreButton(_ sender: UIBarButtonItem) {
        showActionSheet()
    }
    
    func showActionSheet() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let restartAction = UIAlertAction(title: "Restart", style: .default)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let logOutAction = UIAlertAction(title: "Log Out", style: .destructive) { _ in
            self.dismiss(animated: true)
        }
        
        alertController.addAction(restartAction)
        alertController.addAction(cancelAction)
        alertController.addAction(logOutAction)
        
        present(alertController, animated: true)
    }
    
}
