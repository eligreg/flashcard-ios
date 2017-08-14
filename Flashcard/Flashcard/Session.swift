//
//  Session.swift
//  Flashcard
//
//  Created by Eli Gregory on 7/23/17.
//  Copyright © 2017 Eli Gregory. All rights reserved.
//

import Foundation
import RealmSwift

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
    
    // MARK: Restoring a Session
    
    static var isRestored: Bool {
        get {
            let r = restored
            restored = false
            return r
        }
    }
    
    fileprivate static var restored: Bool = false
    
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
            restored = true
        }
        else {
            save()
        }
    }
    
    fileprivate static var currentDeckIdUserDefaultKey = "com.achimllc.flashcard.currentDeckIdUserDefaultKey"

}
