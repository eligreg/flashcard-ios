//
//  Errors.swift
//  Flashcard
//
//  Created by Eli Gregory on 7/28/17.
//  Copyright © 2017 Eli Gregory. All rights reserved.
//

import Foundation
import BPStatusBarAlert
import Crashlytics

class StatusBar {
    
    static func display(message: String?) {
        BPStatusBarAlert(duration: 2.0, delay: 0.4, position: .statusBar)
            .message(message: message ?? "Unknown Error!")
            .messageColor(color: .white)
            .bgColor(color: .red)
            .show()
    }
}

struct FlashcardError {
    static let domain: String = "com.achimllc.flashcard"
    
    // MARK: General Errors, 100s
    
    static let invalidJSONError: NSError = {
        return NSError(domain: domain,
                       code: 101,
                       userInfo: ["message": "Oops, there was a Server error.",
                                  "meta": "Response is invalid JSON"])
    }()
    
    static let invalidSecretsError: NSError = {
        return NSError(domain: domain,
                       code: 102,
                       userInfo: ["message": "Couldn't load Secrets Document.",
                                  "meta": "Response is invalid JSON"])
    }()
    
    static let invalidSecretsTokenError: NSError = {
        return NSError(domain: domain,
                       code: 103,
                       userInfo: ["message": "Couldn't load Secrets Request Token.",
                                  "meta": "Response is invalid JSON"])
    }()
    
    static let invalidSecretsBaseURLError: NSError = {
        return NSError(domain: domain,
                       code: 104,
                       userInfo: ["message": "Couldn't load Secrets Base URL.",
                                  "meta": "Response is invalid JSON"])
    }()
    
    // MARK: Deck Errors, 200s
    
    static let deckJSONDecodeError: NSError = {
        return NSError(domain: domain,
                       code: 201,
                       userInfo: ["message": "Oops, there was a Server error.",
                                  "meta": "Could not serialize Deck JSON"])
    }()
    
    static func deckResponseError(message msg: String) -> NSError {
        return NSError(domain: domain,
                       code: 202,
                       userInfo: ["message": msg,
                                  "meta": "User Error: \(msg)"])
    }
    
    // MARK: Card Errors, 300s
    
    static let cardJSONDecodeError: NSError = {
        return NSError(domain: domain,
                       code: 301,
                       userInfo: ["message": "Oops, there was a Server error.",
                                  "meta": "Could not serialize Card JSON"])
    }()
    
    static func cardResponseError(message msg: String) -> NSError {
        return NSError(domain: domain,
                       code: 302,
                       userInfo: ["message": msg,
                                  "meta": "User Error: \(msg)"])
    }
    
    static let cardJSONDeleteError: NSError = {
        return NSError(domain: domain,
                       code: 303,
                       userInfo: ["message": "Oops, there was a Server error.",
                                  "meta": "Could not read Card Delete response"])
    }()
    
    static func log(error err: NSError) {
        Crashlytics.sharedInstance().recordError(err)
    }
    
    static func log(error err: Error) {
        Crashlytics.sharedInstance().recordError(err)
    }
}
