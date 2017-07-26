//
//  Deck.swift
//  Flashcard
//
//  Created by Eli Gregory on 7/23/17.
//  Copyright © 2017 Eli Gregory. All rights reserved.
//

import Foundation
import Alamofire
import Gloss

struct Deck: Decodable {
    
    let id: Int
    let name: String
    let n_cards: Int
    var cards: [Card]?
    
    init(id: Int, name: String, n_cards: Int) {
        self.id = id
        self.name = name
        self.n_cards = n_cards
    }
    
    init(fake id: Int, name: String, n_cards: Int) {
        self.init(id: id, name: name, n_cards: n_cards)
        self.buildFakeCards()
    }
    
    init?(json: JSON) {
        
        guard
            let id: Int = "id" <~~ json,
            let name: String = "name" <~~ json,
            let n_cards: Int = "n_cards" <~~ json
            
            else {
                return nil
        }
        
        self.id = id
        self.name = name
        self.n_cards = n_cards
    }
    
    mutating func setCards(json: JSON) {
        guard
            let cardsArray: [JSON] = "cards" <~~ json,
            let cards: [Card] = [Card].from(jsonArray: cardsArray) else {
            return
        }
        
        self.cards = cards
    }
    
    mutating func shuffle() {
        
        guard cards != nil, cards!.count > 1 else {
            return
        }
        
        for _ in (0..<cards!.count * 2) {
            let before = Int(arc4random_uniform(UInt32(cards!.count)))
            let card = cards!.remove(at: before)
            let after = Int(arc4random_uniform(UInt32(cards!.count)))
            cards!.insert(card, at: after)
        }
        print(cards!)
    }
    
    var top: Card? {
        
        guard let cards = cards, cards.count > 0 else {
            return nil
        }
        
        return cards.first
    }
    
    mutating func next() -> Card? {
        
        guard cards != nil else {
            return nil
        }
        
        guard let card = cards?.removeFirst() else {
            return nil
        }
        
        cards?.append(card)
        
        return top
    }
    
    mutating func previous() -> Card? {
        
        guard cards != nil else {
            return nil
        }
        
        guard let card = cards?.removeLast() else {
            return nil
        }
        
        cards?.insert(card, at: 0)
        
        return top
    }
}

extension Deck {
    static var current: Deck?
}

extension Deck: CustomStringConvertible {
    var description: String {
        return "[Deck]: \(name), (n):\(n_cards)"
    }
    
    var status: String {
        return "\(name): (\(n_cards))"
    }
}

// MARK: Networking

extension Deck {
    
    static func decks(results: @escaping ([Deck]?) -> Void) {

        Alamofire.request(Routes.decksList()).responseJSON { (response: DataResponse<Any>) in
            
        }
    }
}

// MARK: Fake Networking

extension Deck {
    
    static func fakeDecks(results: @escaping ([Deck]?) -> Void) {
        let decks = [
            Deck(fake: 1, name: "Julia's Deck", n_cards: 12),
            Deck(fake: 2, name: "Jaiya's Deck", n_cards: 8),
            Deck(fake: 3, name: "Eli's Deck", n_cards: 7)
        ]
        
        results(decks)
    }
    
    mutating func buildFakeCards() {
        self.cards = Card.fakeCards(n: self.n_cards)
    }
}
