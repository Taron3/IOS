//
//  ViewController.swift
//  MemoryGame
//
//  Created by 3 on 9/3/19.
//  Copyright © 2019 Taron. All rights reserved.
//

import UIKit

class MemoryGameViewController: UIViewController {
    @IBOutlet weak var flipCountLabel: UILabel!
    @IBOutlet var cardButtons: [UIButton]!
    
    lazy var game = MemoryGame(numberOfPairsOfCards: (cardButtons.count + 1) / 2)
    
    let waitSeconds = 0.7
    var emojiChoices = "🦆🦅🦉🦇🐝🐛🐌🦋🐞🐜🦟🦗🕷🦂🐢🦎🐍🦖🦕🐙🦑🦐🦞🦀🐡🐠🐳🐬🦈🐊🐋🐅🐆🦓🦛🐘🦏🐫🐃🦘🦒🐂🐎🐖🐏🐑🦙🐐🦌🐕🐩🐈🐓🦃🦚🦜🦢🕊🐇🦝🦡🐁🐀🐿🦔🐉"
    var emoji = [Card: String]()
    
    
    var flipCount: Int = 0 {
        didSet {
            flipCountLabel.text = "Flips: \(flipCount)"
        }
    }
    
    var theme: String? {
        didSet {
            emojiChoices = theme ?? ""
            emoji = [:]
            updateViewFromModel()
        }
    }
    
    @IBAction func touchButton(_ sender: UIButton) {
        if let cardNumber = cardButtons.firstIndex(of: sender) {
            flipCount += 1
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        }
    }

    @IBAction func newGameButton(_ sender: UIButton) {
        game = MemoryGame(numberOfPairsOfCards: (cardButtons.count + 1) / 2)
        flipCount = 0
        emoji = [:]
        emojiChoices = theme ?? ""
        
        for index in cardButtons.indices {
            let button = cardButtons[index]
            button.isEnabled = true
        }
        updateViewFromModel()
    }
    
    func updateViewFromModel() {
        if cardButtons != nil {
            if isWon() {
                User.shared.score += 1
            }
            
            for index in cardButtons.indices {
                let button = cardButtons[index]
                let card = game.cards[index]
                if card.isFaceUp {
                    button.isEnabled = false
                    button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                    button.setTitle(emoji(for: card), for: UIControl.State.normal)
                    if game.isFaceUpTwoCards {
                        Timer.scheduledTimer(withTimeInterval: waitSeconds, repeats: false) { _ in
                            button.backgroundColor = #colorLiteral(red: 0.9106613994, green: 0.7467906475, blue: 0.5529863238, alpha: 1)
                            button.setTitle("", for: UIControl.State.normal)
                            button.isEnabled = true
                        }
                    }
                    if game.isMatchedTwoCards {
                        Timer.scheduledTimer(withTimeInterval: waitSeconds, repeats: false) { _ in
                            button.backgroundColor = #colorLiteral(red: 0.3762938236, green: 0.9768045545, blue: 0.6371897408, alpha: 0)
                            button.setTitle("", for: UIControl.State.normal)
                            button.isEnabled = false
                        }
                    }
                } else {
                    button.backgroundColor = card.isMatched ? #colorLiteral(red: 0.3762938236, green: 0.9768045545, blue: 0.6371897408, alpha: 0) : #colorLiteral(red: 0.9106613994, green: 0.7467906475, blue: 0.5529863238, alpha: 1)
                    button.setTitle("", for: UIControl.State.normal)
                }
            }
        }
    }
    
    func isWon() -> Bool {
        var enabledButtonCount = 0
        cardButtons.forEach { if $0.isEnabled { enabledButtonCount += 1 } }
        
        return enabledButtonCount == 2
    }
    
    func emoji(for card: Card) -> String {
        if emoji[card] == nil && emojiChoices.count > 0 {
            let randomStringIndex = emojiChoices.index(emojiChoices.startIndex, offsetBy: Int.random(in: 0...emojiChoices.count)) 
            emoji[card] = String(emojiChoices.remove(at: randomStringIndex))
        }
        return emoji[card] ?? "?"
    }
    
}

