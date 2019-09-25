//
//  MemoryGameThemeChooserViewController.swift
//  MemoryGame
//
//  Created by 3 on 9/16/19.
//  Copyright © 2019 Taron. All rights reserved.
//

import UIKit

class MemoryGameThemeChooserViewController: UIViewController {
    
    let themes = [
        "Animals": "🦆🦅🦉🦇🐝🐛🐌🦋🐞🐜🦟🦗🕷🦂🐢🦎🐍🦖🦕🦐🦞🦀🐡🐠🐳🐬🦈🐊🐋🐅🐆🦓🦛🐘🦏🐫🐃🦘🦒🐂🐎🐖🐏🦙🐐🦌🐕🐩🐈🐓🦃🦚🦜🦢🕊🐇🦝🦡🐁🐀🐿🦔🐉",
        "Food": "🍏🍎🍐🍊🍋🍌🍉🍇🍓🍈🍒🍑🥭🍍🥥🥝🍅🍆🥑🥦🥬🥒🌶🌽🥕🥔🍠",
        "Letters": "ABCDEFGHIJKLNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz" ]
    
    
    var splitViewDetailMemoryGameViewController: MemoryGameViewController? {
        return splitViewController?.viewControllers.last as? MemoryGameViewController
    }
    
    var lastSeguedToMemoryGameViewController: MemoryGameViewController?
    
    @IBAction func changeThemeButton(_ sender: Any) {
        guard let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName] else {
            return
        }
        if let mgvc = splitViewDetailMemoryGameViewController {
            mgvc.theme = theme
        } else if let mgvc = lastSeguedToMemoryGameViewController {
            print("iphone")
            mgvc.theme = theme
            navigationController?.pushViewController(mgvc, animated: true)
        } else {
            print("else")
            performSegue(withIdentifier: "Choose Theme", sender: sender)
        }
        
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("prepare")
        if segue.identifier == "Choose Theme" {
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName] {
                if let mgvc = segue.destination as? MemoryGameViewController {
                    mgvc.theme = theme
                    lastSeguedToMemoryGameViewController = mgvc
                }
            }
        }
    }
    
    
}

extension MemoryGameThemeChooserViewController: UISplitViewControllerDelegate {
    override func awakeFromNib() {
        splitViewController?.delegate = self
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        
        if let mgvc = secondaryViewController as? MemoryGameViewController {
            lastSeguedToMemoryGameViewController = mgvc
            return true
        }
        return false
    }
}
