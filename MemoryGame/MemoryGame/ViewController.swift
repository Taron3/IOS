//
//  ViewController.swift
//  MemoryGame
//
//  Created by 3 on 9/3/19.
//  Copyright © 2019 Taron. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var game = MemoryGame(numberOfPairsOfCards: (cardButtons.count + 1) / 2)
    var flipCount: Int = 0 { didSet { flipCountLabel.text = "Flips: \(flipCount)" } }
    let waitSeconds: Double = 1
    
    @IBOutlet weak var flipCountLabel: UILabel!
    
    @IBOutlet var cardButtons: [UIButton]!
    
    @IBAction func touchButton(_ sender: UIButton) {
        if let cardNumber = cardButtons.firstIndex(of: sender) {
            if !game.cards[cardNumber].isFaceUp {
                flipCount += 1
            }
            game.chooseCard(at: cardNumber)
            
            updateViewFromModel()
        }
    }

    @IBAction func newGameButton(_ sender: UIButton) {
        game = MemoryGame(numberOfPairsOfCards: (cardButtons.count + 1) / 2)
        flipCount = 0
        emoji = [:]
        emojiChoices = ["🐙", "🦑", "🦐", "🦞", "🦀", "🐡", "🐠", "🐳", "🐬", "🦈",
                        "🐊", "🐋", "🐟", "🐅", "🐆", "🦓", "🦛", "🐘", "🦏", "🐫",
                        "🐃", "🦘", "🦒", "🐂", "🐎"]
        for index in cardButtons.indices {
            let button = cardButtons[index]
            button.isEnabled = true
        }
        updateViewFromModel()
    }
    
    func updateViewFromModel() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                button.setTitle(emoji(for: card), for: UIControl.State.normal)
                if game.isFaceUpTwoCards {
                        Timer.scheduledTimer(withTimeInterval: waitSeconds, repeats: false) { (nil) in
                        button.backgroundColor = #colorLiteral(red: 0.9106613994, green: 0.7467906475, blue: 0.5529863238, alpha: 1)
                        button.setTitle("", for: UIControl.State.normal)
                        }
                    }
                if game.isMatchedTwoCards {
                    Timer.scheduledTimer(withTimeInterval: waitSeconds, repeats: false) { (nil) in
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
    
    var emojiChoices = ["🐙", "🦑", "🦐", "🦞", "🦀", "🐡", "🐠", "🐳", "🐬", "🦈",
                        "🐊", "🐋", "🐟", "🐅", "🐆", "🦓", "🦛", "🐘", "🦏", "🐫",
                        "🐃", "🦘", "🦒", "🐂", "🐎"]
    
    var emoji = [Int: String]()
    
    func emoji(for card: Card) -> String {
        let randomIndex = Int(arc4random_uniform(UInt32(emojiChoices.count)))
        if emoji[card.identifier] == nil && emojiChoices.count > 0 {
                emoji[card.identifier] = emojiChoices.remove(at: randomIndex)
            }
        return emoji[card.identifier] ?? "?"
    }
}

