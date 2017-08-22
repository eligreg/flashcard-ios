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
    
    static func get() -> Promise<[Deck]> {
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
    
    static func get(deck: Deck) -> Promise<Deck> {
        return Promise { resolve, reject in
            Alamofire.request(Routes.deck(id: deck.id))
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
    
    static func new(deck name: String) -> Promise<Deck> {
        return Promise { resolve, reject in
            Alamofire.request(Routes.decksNew(name: name))
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
        
    static func getCards(forDeck: Deck) -> Promise<(Deck,[Card])> {
        return Promise { resolve, reject in
            Alamofire.request(Routes.decksCards(id: forDeck.id))
                .responseJSON { (response: DataResponse<Any>) in
                    if let err = response.result.error {
                        reject(err)
                        return
                    }
                    guard let resp = response.response, resp.statusCode == 200 else {
                        print(response.response!.statusCode)
                        if let resp = response.response, (resp.statusCode == 404 || resp.statusCode == 403) {
                            if let deck = Session.deck {
                                do {
                                    let realm = try Realm()
                                    try realm.write {
                                        realm.delete(deck)
                                    }
                                }
                                catch let err as NSError {
                                    reject(err)
                                }
                            }
                            reject(FlashcardError.deckMissing)
                        }
                        else {
                            reject(FlashcardError.serverError)
                        }
                        return
                    }
                    guard let json = response.jsonArray else {
                        reject(FlashcardError.invalidJSON)
                        return
                    }
                    guard let cards = [Card].from(jsonArray: json) else {
                        reject(FlashcardError.cardJSONDecode)
                        return
                    }
                    resolve((forDeck, cards))
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
