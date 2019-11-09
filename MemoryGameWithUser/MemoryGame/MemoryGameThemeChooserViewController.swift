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
        "Letters": "ABCDEFGHIJKLNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
    ]
    
    @IBAction func changeThemeButton(_ sender: Any) {
        guard let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName] else {
            return
        }
        
        let memoryGameVC = storyboard?.instantiateViewController(identifier: "MemoryGameViewController") as! MemoryGameViewController
        memoryGameVC.theme = theme
        navigationController?.pushViewController(memoryGameVC, animated: true)
    }

    
}

