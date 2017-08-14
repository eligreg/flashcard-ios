//
//  JSON+Extensions.swift
//  Flashcard
//
//  Created by Eli Gregory on 7/29/17.
//  Copyright © 2017 Eli Gregory. All rights reserved.
//

import Foundation
import Gloss

extension Dictionary where Key == String, Value == Any {
    
    var errorMessage: String? {
        get {
            guard let error = self["error"] as? Bool, error == true, let message = self["reason"] as? String else {
                return nil
            }
            return message
        }
    }
}
