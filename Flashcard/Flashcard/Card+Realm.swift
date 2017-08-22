//
//  Card+Realm.swift
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

extension Card {
    
    static func add(data: (deck: Deck, card: Card)) -> Promise<(Deck,Card)> {
        return Promise { resolve, reject in
            do {
                let realm = try Realm()
                try realm.write {
                    realm.add(data.card, update: true)
                }
            }
            catch let error as NSError {
                reject(error)
            }
            resolve(data)
        }
    }
    
    static func delete(card: Card) -> Promise<Void> {
        return Promise { resolve, reject in
            do {
                let realm = try Realm()
                try realm.write {
                    realm.delete(card)
                }
            }
            catch let error as NSError {
                reject(error)
            }
            resolve()
        }
    }
}
