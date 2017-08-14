//
//  NSError+Extensions.swift
//  Flashcard
//
//  Created by Eli Gregory on 7/29/17.
//  Copyright © 2017 Eli Gregory. All rights reserved.
//

import Foundation

extension Error {
    
    var userErrorMessage: String? {
        get {
            return (self as NSError).userErrorMessage
        }
    }
    
    var metaErrorMessage: String? {
        get {
            return (self as NSError).metaErrorMessage
        }
    }
}

extension NSError {
    
    var userErrorMessage: String? {
        get {
            return self.userInfo["message"] as? String
        }
    }
    
    var metaErrorMessage: String? {
        get {
            return self.userInfo["meta"] as? String
        }
    }
}
