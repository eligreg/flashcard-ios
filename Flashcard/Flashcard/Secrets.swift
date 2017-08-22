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
    
    struct Keys {        
        static let envToken = "FLASHCARD_ENV_TOKEN"
        static let baseURL = "FLASHCARD_BASE_URL"
    }
    
    fileprivate static func loadSecrets() throws -> JSON {
        
        guard let path = Bundle.main.path(forResource: "secrets", ofType: "json"),
              let contents = try String(contentsOfFile:path, encoding: .utf8).data(using: .utf8),
              let json = try JSONSerialization.jsonObject(with: contents, options: .allowFragments) as? JSON
        
        else {
            throw FlashcardError.invalidSecrets
        }
        
        return json
    }
    
    fileprivate static func loadToken() throws -> String {
        
        let json = try loadSecrets()
        
        guard let env = json[Environment.env] as? JSON, let token = env[Keys.envToken] as? String else {
            throw FlashcardError.invalidSecretsToken
        }
        
        return token
    }
    
    fileprivate static func loadBaseURL() throws -> String {
        
        let json = try loadSecrets()
        
        guard let env = json[Environment.env] as? JSON, let token = env[Keys.baseURL] as? String else {
            throw FlashcardError.invalidSecretsBaseURL
        }
        
        return token
    }
    
    static let requestToken: String = {
        
        do {
            return try loadToken()
        }
        catch let err as NSError {
            print(err)
            FlashcardError.processError(err: err)
            return "xx_fallback_token_xx"
        }
    }()
    
    static let baseURL: String = {
        
        do {
            return try loadBaseURL()
        }
        catch let err as NSError {
            
            print(err)
            FlashcardError.processError(err: err)
            return "http://localhost:8080/"
        }
    }()
}
