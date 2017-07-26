//
//  Card.swift
//  Flashcard
//
//  Created by Eli Gregory on 7/23/17.
//  Copyright © 2017 Eli Gregory. All rights reserved.
//

import Foundation
import Gloss

struct Card: Decodable {
    
    let id: Int
    let front: String
    let back: String
    
    init(id: Int, front: String, back: String) {
        self.id = id
        self.front = front
        self.back = back
    }
    
    init?(json: JSON) {
        
        guard
            let id: Int = "id" <~~ json,
            let front: String = "front" <~~ json,
            let back: String = "back" <~~ json
            
            else {
                return nil
        }
        
        self.id = id
        self.front = front
        self.back = back
    }
}


// MARK: Fake Networking

extension Card {
    
    static func fakeCards(n: Int) -> [Card] {
        var cards = [Card]()

        for i in (0..<n) {
            cards.append( Card(id: i, front: "Front (\(i+1))", back: "Back (\(i+1))") )
        }
        
        return cards
    }
}
