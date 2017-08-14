//
//  Token.swift
//  Flashcard
//
//  Created by Eli Gregory on 8/13/17.
//  Copyright © 2017 Eli Gregory. All rights reserved.
//

import Foundation
import Gloss

class Token {
    
    static let shared = Token()
    
    static var requestToken: String {
        return shared.token ?? "fallback_token"
    }
    
    var token: String?
    
    static func load() {
        
        guard let path = Bundle.main.path(forResource: "token", ofType: "json") else {
            return
        }
        
        do {
            guard let contents = try String(contentsOfFile:path, encoding: .utf8).data(using: .utf8) else {
                return
            }
            
            guard let json = try JSONSerialization.jsonObject(with: contents, options: .allowFragments) as? JSON else {
                return
            }
            
            shared.token = json["FLASHCARD_ENV_TOKEN"] as? String
        }
        catch let err as NSError {
            print(err)
        }
    }
}
