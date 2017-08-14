//
//  Realm+Extensions.swift
//  Flashcard
//
//  Created by Eli Gregory on 8/1/17.
//  Copyright © 2017 Eli Gregory. All rights reserved.
//

import Foundation
import RealmSwift

extension Results {
    
    func toArray() -> [T] {
        return self.map{$0}
    }
}

extension RealmSwift.List {
    
    func toArray() -> [T] {
        return self.map{$0}
    }
}
