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
import then
import RealmSwift

class Deck: Object, Decodable {
    
    struct keys {
        static let id = "id"
        static let name = "name"
        static let n_cards = "n_cards"
    }
    
    dynamic var id: Int = 0
    dynamic var name: String = ""
    fileprivate dynamic var n_cards: Int = 0
    var cards = List<Card>()
    
    var cardsCount: Int {
        return cards.count > 0 ? cards.count : n_cards
    }
    
    override class func primaryKey() -> String? {
        return keys.id
    }
    
    required convenience init?(json: JSON) {
        
        self.init()
        
        guard
            let id: Int = keys.id <~~ json,
            let name: String = keys.name <~~ json,
            let n_cards: Int = keys.n_cards <~~ json
            
            else {
                return nil
        }
        
        self.id = id
        self.name = name
        self.n_cards = n_cards
    }
    
    override var description: String {
        return "[Deck] \(name) - (n):\(cardsCount)"
    }
    
    var status: String {
        return "Deck: \(name) (\(cardsCount))"
    }
}

enum DeckActivity {
    
    case chooseDeck()
    case newDeck()
    
    static var structure: [DeckActivity] {
        return [.newDeck(), .chooseDeck()]
    }
    
    static var rows: Int {
        return structure.count
    }
    
    static func item(forIndexPath indexPath: IndexPath) -> DeckActivity {
        return structure[indexPath.row]
    }
    
    var title: String {
        switch self {
        case .chooseDeck():
            return "Choose Deck"
        case .newDeck():
            return "New Deck"
        }
    }
    
    var segue: String {
        switch self {
        case .chooseDeck():
            return "rootTableToChooseDeck"
        case .newDeck():
            return "rootTableViewToNewDeck"
        }
    }
}
