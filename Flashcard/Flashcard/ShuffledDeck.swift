//
//  ShuffledDeck.swift
//  Flashcard
//
//  Created by Eli Gregory on 8/8/17.
//  Copyright © 2017 Eli Gregory. All rights reserved.
//

import Foundation

class ShuffledDeck {
    
    var deck: Deck? {
        return Session.deck
    }
    var indices = [Int]()
    
    fileprivate var falseTop: Card?
    
    func inject(falseTopCard card:Card) {
        falseTop = card
    }

    init() { }
    
    var status: String {
        return self.deck != nil ? "\(self.deck!.name) (\(self.deck!.cards.count))" : "(No Deck Selected)"
    }
    
    func shuffle() {
        
        guard let deck = deck, deck.cards.count > 0 else {
            indices = [Int]()
            return
        }
        
        indices = Array(0...deck.cards.count-1)
                
        guard indices.count > 1 else {
            return
        }
        
        for _ in (0..<indices.count * 3) {
            let before = Int(arc4random_uniform(UInt32(indices.count)))
            let index = indices.remove(at: before)
            let after = Int(arc4random_uniform(UInt32(indices.count)))
            indices.insert(index, at: after)
        }
    }
    
    var top: Card? {
        
        if falseTop != nil {
            let card = falseTop
            falseTop = nil
            return card
        }
        
        reindex()
        
        guard indices.count > 0 else {
            return nil
        }
        
        return deck?.cards[indices[0]]
    }
    
    func next() -> Card? {
        
        reindex()
        
        guard indices.count > 0 else {
            return nil
        }
        
        let index = indices.removeFirst()
        
        indices.append(index)
        
        return deck?.cards[indices[0]]
    }
    
    func previous() -> Card? {
        
        reindex()
        
        guard indices.count > 0 else {
            return nil
        }
        
        let index = indices.remove(at: indices.count-1)
        
        indices.insert(index, at: 0)
        
        return deck?.cards[indices[0]]
    }
    
    func reindex() {
        
        if indices.count != deck?.cards.count {
            shuffle()
        }
    }
}
