//
//  ViewController.swift
//  Flashcard
//
//  Created by Eli Gregory on 7/19/17.
//  Copyright © 2017 Eli Gregory. All rights reserved.
//

import UIKit
import then
import PKHUD
import RealmSwift
import Morgan

class DeckViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var deckLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var frontLabel: UILabel!
    @IBOutlet weak var backLabel: UILabel!
    @IBOutlet weak var newButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    
    var shuffledDeck: ShuffledDeck?
    
    var showBack: Bool = false {
        didSet {
            backLabel.isHidden = !showBack
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let left = UISwipeGestureRecognizer(target: self,
                                            action: #selector(DeckViewController.swipe(_:)))
        left.direction = .left
        
        let right = UISwipeGestureRecognizer(target: self,
                                             action: #selector(DeckViewController.swipe(_:)))
        right.direction = .right
        
        self.view.addGestureRecognizer(left)
        self.view.addGestureRecognizer(right)
        
        let hold = UILongPressGestureRecognizer(target: self,
                                                action: #selector(DeckViewController.hold))
        hold.minimumPressDuration = 0.8
        
        self.view.addGestureRecognizer(hold)
        
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(DeckViewController.tap))
        
        self.view.addGestureRecognizer(tap)

        shuffledDeck = ShuffledDeck()

        Session.deck?
            .synchronizeCards()
            .onError { err in
                var msg: String = ""
                if err is FlashcardError {
                    msg = err.userErrorMessage!
                }
                else {
                    msg = "\(err.localizedDescription)"
                }
                self.deliver(errorMessage: msg)
            }
            .finally {
                self.shuffledDeck?.shuffle()
                self.update()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.update()
    }
    
    func deliver(errorMessage message: String?) {
        self.errorLabel.text = message
        self.errorLabel.shake()
    }
    
    func swipe(_ sender: UISwipeGestureRecognizer) {
        
        guard showBack == false else {
            return
        }
        
        UIView.animate(withDuration: 0.1, animations: {
            
            self.frontLabel.alpha = 0.0
            self.backLabel.alpha = 0.0
            
        }) { (completion: Bool) in
            
            if sender.direction == .left {
                _ = self.shuffledDeck?.previous()
            }
            else if sender.direction == .right {
                _ = self.shuffledDeck?.next()
            }
            self.frontLabel.alpha = 1.0
            self.backLabel.alpha = 1.0
            
            self.update()
        }
    }
    
    func hold(_ sender: UILongPressGestureRecognizer) {
        guard self.shuffledDeck?.top != nil else {
            return
        }
        showBack = true
    }
    
    func tap(_ sender: UITapGestureRecognizer) {
        showBack = false
    }
    
    func update() {
        let card = self.shuffledDeck?.top
        frontLabel.text = card != nil ? card!.front : ""
        backLabel.text = card != nil ? card!.back  : ""
        deckLabel.text = shuffledDeck?.deck != nil ? shuffledDeck!.status : "(No Deck Selected)"
        newButton.isEnabled = self.shuffledDeck?.deck != nil
    }
    
    @IBAction func returnToRootTableViewController(_ sender: UIButton) {
        self.dismiss(animated: true) { 
            self.shuffledDeck = nil
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

