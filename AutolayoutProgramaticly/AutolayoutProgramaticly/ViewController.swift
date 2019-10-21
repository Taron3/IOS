//
//  ViewController.swift
//  AutolayoutProgramaticly
//
//  Created by 3 on 10/17/19.
//  Copyright © 2019 Taron. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    

    @IBAction func logInButton(_ sender: UIButton) {
        let profileViewController = ProfileViewController()
        profileViewController.modalPresentationStyle = .overFullScreen
        
        present(profileViewController, animated: true)
        
    }
    
}

