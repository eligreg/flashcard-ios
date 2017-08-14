//
//  Secrets.swift
//  Flashcard
//
//  Created by Eli Gregory on 8/13/17.
//  Copyright © 2017 Eli Gregory. All rights reserved.
//

import Foundation
import Gloss

class Secrets {
    
    fileprivate static func loadSecrets() throws -> JSON {
        
        guard let path = Bundle.main.path(forResource: "secrets", ofType: "json"),
              let contents = try String(contentsOfFile:path, encoding: .utf8).data(using: .utf8),
              let json = try JSONSerialization.jsonObject(with: contents, options: .allowFragments) as? JSON
        
        else {
            throw FlashcardError.invalidSecretsError
        }
        
        return json
    }
    
    fileprivate static func loadToken() throws -> String {
        
        let json = try loadSecrets()
        
        guard let token = json["FLASHCARD_ENV_TOKEN"] as? String else {
            throw FlashcardError.invalidSecretsTokenError
        }
        
        return token
    }
    
    fileprivate static func loadBaseURL() throws -> String {
        
        let json = try loadSecrets()
        
        guard let token = json["FLASHCARD_BASE_URL"] as? String else {
            throw FlashcardError.invalidSecretsBaseURLError
        }
        
        return token
    }
    
    static let requestToken: String = {
        
        do {
            return try loadToken()
        }
        catch let err as NSError {
            
            print(err)
            StatusBar.display(message: err.userErrorMessage)
            return "xx_fallback_token_xx"
        }
    }()
    
    static let baseURL: String = {
        
        do {
            return try loadBaseURL()
        }
        catch let err as NSError {
            
            print(err)
            StatusBar.display(message: err.userErrorMessage)
            return "http://localhost:8080/"
        }
    }()
}
