//
//  Card+Data.swift
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

extension Card {
    
    static func patch(card: Card, front:String, back:String) -> Promise<Card> {
        return Promise { resolve, reject in
            Alamofire.request(Routes.cardsUpdate(id: card.id, front: front, back: back))
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
                    resolve(card)
                })
        }
    }
    
    static func delete(card: Card) -> Promise<Card> {
        return Promise { resolve, reject in
            Alamofire.request(Routes.cardsDelete(id: card.id))
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
                    guard let success = json["success"] as? Bool else {
                        reject(FlashcardError.cardDelete)
                        return
                    }
                    guard success else {
                        reject(FlashcardError.serverError)
                        return
                    }
                    resolve(card)
                })
        }
    }
}
