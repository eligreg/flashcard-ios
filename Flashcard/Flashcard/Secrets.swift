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
    
    static let requestToken: String? = {
        
        guard let path = Bundle.main.path(forResource: "secrets", ofType: "json") else {
            return nil
        }
        
        do {
            guard let contents = try String(contentsOfFile:path, encoding: .utf8).data(using: .utf8) else {
                return nil
            }
            
            guard let json = try JSONSerialization.jsonObject(with: contents, options: .allowFragments) as? JSON else {
                return nil
            }
            
            return json["FLASHCARD_ENV_TOKEN"] as? String
        }
        catch let err as NSError {
            print(err)
            StatusBar.display(message: "Error loading Request Token")
            return nil
        }
    }()
}
