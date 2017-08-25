//
//  Deck+Realm.swift
//  Flashcard
//
//  Created by Eli Gregory on 8/20/17.
//  Copyright © 2017 Eli Gregory. All rights reserved.
//

import Foundation
import then
import Alamofire
import Gloss
import RealmSwift

extension Deck {

    static func fetchLocal() -> Promise<[Deck]> {
        return Promise { resolve, reject in
            do {
                let realm = try Realm()
                let decks:[Deck] = realm.objects(Deck.self).map({ return $0 })
                resolve(decks)
            }
            catch let error as NSError {
                reject(error)
            }
        }
    }
    
    static func synchronizeLocalDecks(decks: [Deck]) -> Promise<[Deck]> {
        return Promise { resolve, reject in
            do {
                let realm = try Realm()
                var deckIds = Set(realm.objects(Deck.self).map({ return $0.id }))
                try realm.write {
                    // Iterate through all Decks
                    for deck in decks {
                        // Add or Update all Decks in response
                        realm.add(deck, update: true)
                        // Find which Decks to delete
                        if deckIds.contains(deck.id) {
                            deckIds.remove(deck.id)
                        }
                    }
                    // Delete unwanted Decks
                    let unwanted = realm.objects(Deck.self).filter({ (deck: Deck) -> Bool in
                        deckIds.contains(deck.id)
                    })
                    realm.delete(unwanted)
                    let decks = realm.objects(Deck.self).toArray()
                    resolve(decks)
                }
            }
            catch let error as NSError {
                reject(error)
            }
        }
    }
    
    // TODO REMOVE
    static func addLocal(deck: Deck) -> Promise<Deck> {
        return Promise { resolve, reject in
            do {
                let realm = try Realm()
                try realm.write {
                    realm.add(deck, update: true)
                }
            }
            catch let error as NSError {
                reject(error)
            }
            resolve(deck)
        }
    }
    // END REMOVE
    
    func synchronizeLocalCards(cards: [Card]) -> Promise<Void> {
        return Promise { resolve, reject in
            do {
                let realm = try Realm()
                var cardIds = Set<Int>()
                if let deck = realm.object(ofType: Deck.self, forPrimaryKey: self.id) {
                    cardIds = Set(deck.cards.map({ $0.id }))
                }
                try realm.write {
                    for card in cards {
                        realm.add(cards, update: true)
                        if !self.cards.contains(card) {
                            self.cards.append(card)
                        }
                        if cardIds.contains(card.id) {
                            cardIds.remove(card.id)
                        }
                    }
                    let unwanted = realm.objects(Card.self).filter({ (card: Card) -> Bool in
                        return cardIds.contains(card.id)
                    })
                    var removalIndexes = [Int]()
                    for (index, card) in unwanted.enumerated() {
                        if self.cards.contains(card) {
                            removalIndexes.append(index)
                        }
                    }
                    for index in removalIndexes {
                        self.cards.remove(objectAtIndex: index)
                    }
                    if let sessionDeck = Session.deck {
                        if removalIndexes.contains(sessionDeck.id) {
                            Session.deck = nil
                        }
                    }
                    realm.delete(unwanted)
                }
            }
            catch let error as NSError {
                reject(error)
            }
            resolve()
        }
    }
    
    func insertLocal(card: Card) -> Promise<Void> {
        return Promise { resolve, reject in
            do {
                let realm = try Realm()
                try realm.write {
                    self.cards.append(card)
                }
            }
            catch let err as NSError {
                reject(err)
            }
            resolve()
        }
    }
    
    // TODO DELETE
    static func insertLocal(data: (deck: Deck, card: Card)) -> Promise<Void> {
        return Promise { resolve, reject in
            do {
                let realm = try Realm()
                try realm.write {
                    data.deck.cards.append(data.card)
                }
            }
            catch let err as NSError {
                reject(err)
            }
            resolve()
        }
    }
    // END DELETE
}
