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
    
    static func getAllRemote() -> Promise<[Deck]> {
        return Promise { resolve, reject in
            Alamofire.request(Routes.decksList())
                .responseJSON { (response: DataResponse<Any>) in
                    if let err = response.error {
                        print(err.localizedDescription)
                        reject(err)
                        return
                    }
                    guard let json = response.jsonArray else {
                        reject(FlashcardError.invalidJSON)
                        return
                    }
                    guard let decks = [Deck].from(jsonArray: json) else {
                        reject(FlashcardError.deckJSONDecode)
                        return
                    }
                    resolve(decks)
            }
        }
    }
    
    func getRemote() -> Promise<Deck> {
        return Promise { resolve, reject in
            Deck.getRemote(deck: self)
                .then ({ deck in
                    resolve(deck)
                })
                .onError ({ err in
                    reject(err)
                })
        }
    }
    
    static func getRemote(deck: Deck) -> Promise<Deck> {
        return Promise { resolve, reject in
            Alamofire.request(Routes.deck(id: deck.id))
                .responseJSON(completionHandler: { (response: DataResponse<Any>) in
                    if let err = response.error {
                        reject(err)
                        return
                    }
                    guard !response.resourceIsMissing else {
                        reject(FlashcardError.deckMissing)
                        return
                    }
                    guard let json = response.json else {
                        reject(FlashcardError.invalidJSON)
                        return
                    }
                    guard let deck = Deck(json: json) else {
                        reject(FlashcardError.deckJSONDecode)
                        return
                    }
                    resolve(deck)
                })
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
                    guard !response.resourceIsMissing else {
                        reject(FlashcardError.deckMissing)
                        return
                    }
                    guard let json = response.json else {
                        reject(FlashcardError.invalidJSON)
                        return
                    }
                    guard !response.forbidden else {
                        let reason = json.errorMessage ?? "Unknown Error!"
                        reject(FlashcardError.deckResponse(msg: reason))
                        return
                    }
                    guard let deck = Deck(json: json) else {
                        reject(FlashcardError.deckJSONDecode)
                        return
                    }
                    resolve(deck)
                })
        }
    }
    
    func getRemoteCards() -> Promise<([Card])> {
        return Promise { resolve, reject in
            Deck.getRemoteCards(deck: self)
                .then ({ cards in
                    resolve(cards)
                })
                .onError({ err in
                    reject(err)
                })
        }
    }
    
    static func getRemoteCards(deck: Deck) -> Promise<[Card]> {
        return Promise { resolve, reject in
            Alamofire.request(Routes.decksCards(id: deck.id))
                .responseJSON { (response: DataResponse<Any>) in
                    if let err = response.result.error {
                        reject(err)
                        return
                    }
                    guard !response.resourceIsMissing else {
                        reject(FlashcardError.deckMissing)
                        return
                    }
                    guard let jsonArray = response.jsonArray else {
                        if let json = response.json {
                            let reason = json.errorMessage ?? "Unknown Error!"
                            reject(FlashcardError.deckResponse(msg: reason))
                        }
                        reject(FlashcardError.invalidJSON)
                        return
                    }
                    guard !response.forbidden else {
                        return
                    }
                    guard let cards = [Card].from(jsonArray: jsonArray) else {
                        reject(FlashcardError.cardJSONDecode)
                        return
                    }
                    resolve(cards)
            }
        }
    }
    
    static func patch(deck: Deck, withName name: String) -> Promise<Deck> {
        return Promise { resolve, reject in
            Alamofire.request(Routes.decksUpdate(id: deck.id, name: name))
                .responseJSON(completionHandler: { (response: DataResponse<Any>) in
                    if let err = response.error {
                        reject(err)
                        return
                    }
                    guard let json = response.json else {
                        reject(FlashcardError.invalidJSON)
                        return
                    }
                    if let message = json.errorMessage {
                        reject(FlashcardError.deckResponse(msg: message))
                        return
                    }
                    guard let deck = Deck(json: json) else {
                        reject(FlashcardError.deckJSONDecode)
                        return
                    }
                    resolve(deck)
                })
        }
    }
    
    func newRemoteCard(front: String, back: String) -> Promise<Card> {
        return Card.newRemoteFor(deck: self, front: front, back: back)
    }
    
    static func new(cardForDeck deck: Deck, front:String, back:String) -> Promise<(Deck,Card)> {
        return Promise { resolve, reject in
            Alamofire.request(Routes.cardsNew(deck_id: deck.id, front: front, back: back))
                .responseJSON(completionHandler: { (response: DataResponse<Any>) in
                    if let err = response.error {
                        reject(err)
                        return
                    }
                    guard let json = response.json else {
                        reject(FlashcardError.invalidJSON)
                        return
                    }
                    if let message = json.errorMessage {
                        reject(FlashcardError.cardResponse(msg: message))
                        return
                    }
                    guard let card = Card(json: json) else {
                        reject(FlashcardError.cardJSONDecode)
                        return
                    }
                    resolve((deck, card))
                })
        }
    }
}
