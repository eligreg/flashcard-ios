//
//  Card.swift
//  Flashcard
//
//  Created by Eli Gregory on 7/23/17.
//  Copyright © 2017 Eli Gregory. All rights reserved.
//

import Foundation
import Gloss
import RealmSwift

class Card: Object, Decodable {
    
    struct keys {
        static let id = "id"
        static let front = "front"
        static let back = "back"
        static let deck_id = "deck_id"
    }
    
    dynamic var id: Int = 0
    dynamic var front: String = ""
    dynamic var back: String = ""
    
    required convenience init?(json: JSON) {

        self.init()
        
        guard
            let id: Int = keys.id <~~ json,
            let front: String = keys.front <~~ json,
            let back: String = keys.back <~~ json
            
            else {
                return nil
        }
        
        self.id = id
        self.front = front
        self.back = back
    }
    
    override class func primaryKey() -> String? {
        return keys.id
    }
}

