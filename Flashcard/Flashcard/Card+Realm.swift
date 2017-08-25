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
    
    static func addLocal(card: Card) -> Promise<Card> {
        return Promise { resolve, reject in
            do {
                let realm = try Realm()
                try realm.write {
                    realm.add(card, update: true)
                }
            }
            catch let error as NSError {
                reject(error)
            }
            resolve(card)
        }
    }
    
    func updateLocalWith(card: Card) -> Promise<Card> {
        return Promise { resolve, reject in
            do {
                let realm = try Realm()
                try realm.write {
                    self.id = card.id
                    self.front = card.front
                    self.back = card.back
                }
            }
            catch let error as NSError {
                reject(error)
            }
            resolve(card)
        }
    }
    
    func deleteLocal() -> Promise<Void> {
        return Promise { resolve, reject in
            do {
                let realm = try Realm()
                try realm.write {
                    realm.delete(self)
                }
            }
            catch let error as NSError {
                reject(error)
            }
            resolve()
        }
    }
}
