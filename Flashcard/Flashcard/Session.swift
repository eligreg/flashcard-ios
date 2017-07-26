//
//  Session.swift
//  Flashcard
//
//  Created by Eli Gregory on 7/23/17.
//  Copyright © 2017 Eli Gregory. All rights reserved.
//

import Foundation

class Session {
    
    fileprivate static let shared = Session()
    
    fileprivate var deck: Deck?
    
    static var deck: Deck? {
        get {
            return shared.deck
        }
        set {
            shared.deck = newValue
        }
    }
}
