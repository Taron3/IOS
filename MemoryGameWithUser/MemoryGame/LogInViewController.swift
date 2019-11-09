//
//  LogInViewController.swift
//  MemoryGame
//
//  Created by 3 on 11/8/19.
//  Copyright © 2019 Taron. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController {
    @IBOutlet weak var usernameLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    
    let username = "username"
    let password = "password"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        observingKeyboardNotifications()
        hideKeyboardWhenTappedAround()
    }
    
    func observingKeyboardNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }

    @IBAction func logInButton(_ sender: UIButton) {
        guard let username = usernameLabel.text, let password = passwordLabel.text else {
            return
        }
        
        if username == self.username, password == self.password {
            showUserProfileViewController()
            User.shared.isLoggedIn = true
            usernameLabel.text = ""
            passwordLabel.text = ""
        } else {
            showAlertController()
        }
        
    }

    func showUserProfileViewController() {
        NotificationCenter.default.post(name: NSNotification.Name.isLoggedIn,
                                        object: nil,
                                        userInfo: nil)
        dismiss(animated: false)
    }
    
    func showAlertController() {
        let alertController = UIAlertController(title: nil, message: "Wrong username or passwprd", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)

        present(alertController, animated: true)
    }
    
    
    @objc func keyboardWillShow(note: NSNotification) {
        guard let userInfo = note.userInfo,
            let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
                return
        }
        
        let keyboardFrame = keyboardSize.cgRectValue
        if view.frame.origin.y == 0 {
            view.frame.origin.y -= keyboardFrame.height / 2
        }
    }
    
    @objc func keyboardWillHide(note: NSNotification) {
        if view.frame.origin.y != 0 {
            view.frame.origin.y = 0
        }
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = true
        view.addGestureRecognizer(tap)
    }
     
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
}

