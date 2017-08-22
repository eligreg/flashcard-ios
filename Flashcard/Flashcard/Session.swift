//
//  Session.swift
//  Flashcard
//
//  Created by Eli Gregory on 7/23/17.
//  Copyright © 2017 Eli Gregory. All rights reserved.
//

import Foundation
import RealmSwift
import then
import Alamofire

class Session {
    
    fileprivate static let shared = Session()
    
    fileprivate var sessionDeckID: Int?
    
    static var deck: Deck? {
        get {
            guard let id = shared.sessionDeckID else {
                return nil
            }
            do {
                let realm = try Realm()
                return realm.object(ofType: Deck.self, forPrimaryKey: id)
            }
            catch let error as NSError {
                print(error)
                return nil
            }
        }
        set {
            shared.sessionDeckID = newValue?.id
        }
    }
    
    static func sychronize() -> Promise<Deck?> {
        return Promise<Deck?> { resolve, reject in
            guard let deck = deck else {
                resolve(nil)
                return
            }
            Deck.get(deck: deck)
                .then(Deck.addLocal)
                .then ({ deck in
                    self.deck = deck
                })
                .onError({ err in
                    self.deck = nil
                    FlashcardError.processError(err: err)
                })
                .finally({
                    resolve(self.deck)
                })
        }
    }
    
    // MARK: Restoring a Session or forcing a push
    
    static var shouldPushDeck: Bool {
        get {
            let r = push
            push = false
            return r && deck != nil
        }
    }
    
    static func pushDeck() {
        if deck != nil {
            push = true
        }
    }
    
    internal static var push: Bool = false
    
    // MARK: Injecting a False Top Card
    
    // TODO
    
    // MARK: UserDefaults

    static func save() {
        
        let defs = UserDefaults.standard
        
        if let deck = deck {
            defs.set(deck.id, forKey: Session.currentDeckIdUserDefaultKey)
        }
        else {
            defs.removeObject(forKey: Session.currentDeckIdUserDefaultKey)
        }
        
        defs.synchronize()
    }
    
    static func restore() {
        
        let defs = UserDefaults.standard
        let deckId = defs.integer(forKey: Session.currentDeckIdUserDefaultKey)
        
        guard deckId != 0 else {
            shared.sessionDeckID = nil
            return
        }
        
        shared.sessionDeckID = deckId
        
        if deck != nil {
            push = true
        }
        else {
            save()
        }
    }
    
    fileprivate static var currentDeckIdUserDefaultKey: String {
        return "com.achimllc.flashcard.currentDeckIdUserDefaultKey.\(Environment.env)"
    }

}
