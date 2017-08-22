//
//  Environment.swift
//  Flashcard
//
//  Created by Eli Gregory on 8/17/17.
//  Copyright © 2017 Eli Gregory. All rights reserved.
//

import Foundation

class Environment {
    
    static let debug = "debug"
    static let release = "release"
    
    static var env: String {
        #if DEBUG
            return debug
        #else
            return release
        #endif
    }
}
