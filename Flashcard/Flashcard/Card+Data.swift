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
    
    func patch(card front:String, back:String) -> Promise<Void> {
        return Promise { resolve, reject in
            Alamofire.request(Routes.cardsUpdate(id: self.id, front: front, back: back))
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
                        }
                    }
                    catch let error as NSError {
                        reject(error)
                    }
                    resolve()
                })
        }
    }
    
    func delete() -> Promise<Bool> {
        return Promise { resolve, reject in
            Alamofire.request(Routes.cardsDelete())
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
                    guard let success = json["success"] as? Bool else {
                        reject(FlashcardError.cardJSONDeleteError)
                        return
                    }
                    if success {
                        do {
                            let realm = try Realm()
                            try realm.write {
                                realm.delete(self)
                            }
                        }
                        catch let error as NSError {
                            reject(error)
                        }
                    }
                    resolve(success)
                })
        }
    }
}
