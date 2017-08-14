//
//  Deck+Data.swift
//  Flashcard
//
//  Created by Eli Gregory on 8/11/17.
//  Copyright © 2017 Eli Gregory. All rights reserved.
//

import Foundation
import then
import Alamofire
import Gloss
import RealmSwift

// MARK: Deck Network Calls

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
    
    static func synchronize() -> Promise<[Deck]> {
        return Promise { resolve, reject in
            Alamofire.request(Routes.decksList())
                .responseJSON { (response: DataResponse<Any>) in
                    if let err = response.error {
                        reject(err)
                        return
                    }
                    guard let json = response.jsonArray else {
                        reject(FlashcardError.invalidJSONError)
                        return
                    }
                    guard let decks = [Deck].from(jsonArray: json) else {
                        reject(FlashcardError.deckJSONDecodeError)
                        return
                    }
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
                            //                            if Session.deck != nil, deckIds.contains(Session.deck!.id) {
                            //                                Session.deck = nil
                            //                            }
                            // Delete unwanted Decks
                            let unwanted = realm.objects(Deck.self).filter({ (deck: Deck) -> Bool in
                                deckIds.contains(deck.id)
                            })
                            realm.delete(unwanted)
                        }
                    }
                    catch let error as NSError {
                        reject(error)
                    }
                    resolve(decks)
            }
        }
    }
    
    static func new(deck name: String) -> Promise<Deck> {
        return Promise { resolve, reject in
            Alamofire.request(Routes.decksNew(name: name))
                .responseJSON(completionHandler: { (response: DataResponse<Any>) in
                    if let err = response.error {
                        reject(err)
                        return
                    }
                    guard let json = response.json else {
                        reject(FlashcardError.invalidJSONError)
                        return
                    }
                    if let message = json.errorMessage {
                        reject(FlashcardError.deckResponseError(message: message))
                        return
                    }
                    guard let deck = Deck(json: json) else {
                        reject(FlashcardError.deckJSONDecodeError)
                        return
                    }
                    do {
                        let realm = try Realm()
                        try realm.write {
                            realm.add(deck)
                        }
                    }
                    catch let error as NSError {
                        reject(error)
                    }
                    resolve(deck)
                })
        }
    }
    
    func synchronizeCards() -> Promise<Void> {
        return Promise { resolve, reject in
            Alamofire.request(Routes.decksCards(id: self.id))
                .responseJSON { (response: DataResponse<Any>) in
                    if let err = response.error {
                        reject(err)
                        return
                    }
                    guard let json = response.jsonArray else {
                        reject(FlashcardError.invalidJSONError)
                        return
                    }
                    guard let cards = [Card].from(jsonArray: json) else {
                        reject(FlashcardError.cardJSONDecodeError)
                        return
                    }
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
    }
    
    func patch(name nam: String) -> Promise<Void> {
        return Promise { resolve, reject in
            Alamofire.request(Routes.decksUpdate(id: self.id, name: nam))
                .responseJSON(completionHandler: { (response: DataResponse<Any>) in
                    if let err = response.error {
                        reject(err)
                        return
                    }
                    guard let json = response.json else {
                        reject(FlashcardError.invalidJSONError)
                        return
                    }
                    if let message = json.errorMessage {
                        reject(FlashcardError.deckResponseError(message: message))
                        return
                    }
                    guard let deck = Deck(json: json) else {
                        reject(FlashcardError.deckJSONDecodeError)
                        return
                    }
                    do {
                        let realm = try Realm()
                        try realm.write {
                            realm.add(deck, update: true)
                        }
                    }
                    catch let error as NSError {
                        reject(error)
                    }
                    resolve()
                })
        }
    }
    
    func new(card front:String, back:String) -> Promise<Void> {
        return Promise { resolve, reject in
            Alamofire.request(Routes.cardsNew(deck_id: self.id, front: front, back: back))
                .responseJSON(completionHandler: { (response: DataResponse<Any>) in
                    if let err = response.error {
                        reject(err)
                        return
                    }
                    guard let json = response.json else {
                        reject(FlashcardError.invalidJSONError)
                        return
                    }
                    if let message = json.errorMessage {
                        reject(FlashcardError.cardResponseError(message: message))
                        return
                    }
                    guard let card = Card(json: json) else {
                        reject(FlashcardError.cardJSONDecodeError)
                        return
                    }
                    do {
                        let realm = try Realm()
                        try realm.write {
                            realm.add(card, update: true)
                            self.cards.insert(card, at: 0)
                        }
                    }
                    catch let error as NSError {
                        reject(error)
                    }
                    resolve()
                })
        }
    }
}
