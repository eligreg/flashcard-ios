//
//  ViewController.swift
//  Flashcard
//
//  Created by Eli Gregory on 7/19/17.
//  Copyright © 2017 Eli Gregory. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var deckLabel: UILabel!
    @IBOutlet weak var frontLabel: UILabel!
    @IBOutlet weak var backLabel: UILabel!
    @IBOutlet weak var newButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    
    var deck: Deck?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let left = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.swipe(_:)))
        left.direction = .left
        
        let right = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.swipe(_:)))
        right.direction = .right
        
        self.view.addGestureRecognizer(left)
        self.view.addGestureRecognizer(right)
        
        self.deck = Session.deck
        deckLabel.text = deck != nil ? deck!.status : "(no deck selected)"
        deck?.shuffle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        update(forCard: deck?.top)
    }
    
    func swipe(_ sender: UISwipeGestureRecognizer) {
        if sender.direction == .left {
            _ = deck?.previous()
        }
        else if sender.direction == .right {
            _ = deck?.next()
        }
        update(forCard: self.deck?.top)
    }
    
    func update(forCard card: Card?) {
        frontLabel.text = card != nil ? card!.front : ""
         backLabel.text = card != nil ? card!.back  : ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

