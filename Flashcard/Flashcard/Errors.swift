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

enum FlashcardError: Error {
    // 100s
    case invalidJSON
    case invalidSecrets
    case invalidSecretsToken
    case invalidSecretsBaseURL
    case serverError
    // 200s
    case deckJSONDecode
    case deckResponse(msg:String)
    case deckMissing
    // 300s
    case cardJSONDecode
    case cardResponse(msg:String)
    case cardMissing
    case cardDelete
    
    var message: String {
        switch self {
        case .invalidJSON: return "Oops, there was a server error."
        case .invalidSecrets: return "Oops, there was a local error."
        case .invalidSecretsToken: return "Oops, there was a local error."
        case .invalidSecretsBaseURL: return "Oops, there was a local error."
        case .serverError: return "Oops, there was a server error."

        case .deckJSONDecode: return "Oops, there was a Server error."
        case .deckResponse(let msg): return msg
        case .deckMissing: return "This Deck has been deleted."

        case .cardJSONDecode: return "Oops, there was a Server error."
        case .cardResponse(let msg): return msg
        case .cardMissing: return "This Card has been deleted."
        case .cardDelete: return "This Card cannot be deleted"
        }
    }
    
    var meta: String {
        switch self {
        case .invalidJSON: return "Response is invalid JSON"
        case .invalidSecrets: return "Couldn't load secrets.json"
        case .invalidSecretsToken: return "Couldn't load secrets.json token"
        case .invalidSecretsBaseURL: return "Couldn't load secrets.json base URL"
        case .serverError: return "Generalized Server Error"
            
        case .deckJSONDecode: return "Could not serialize Deck JSON"
        case .deckResponse(let msg): return "User Error: \(msg)"
        case .deckMissing: return "Deck request responded with 404"
            
        case .cardJSONDecode: return "Could not serialize Card JSON"
        case .cardResponse(let msg): return "User Error: \(msg)"
        case .cardMissing: return "Could not read Card Delete response"
        case .cardDelete: return "JSON could not serialize properly."
        }
    }
    
    var code: Int {
        switch self {
        case .invalidJSON: return 101
        case .invalidSecrets: return 102
        case .invalidSecretsToken: return 103
        case .invalidSecretsBaseURL: return 104
        case .serverError: return 105
            
        case .deckJSONDecode: return 201
        case .deckResponse(_): return 202
        case .deckMissing: return 203
            
        case .cardJSONDecode: return 301
        case .cardResponse(_): return 302
        case .cardMissing: return 303
        case .cardDelete: return 304
        }
    }
    
    var localizedDescription: String {
        return message
    }
    
    var domain: String {
        return "com.achimllc.flashcard.error.\(code)"
    }
    
    var nserr: NSError {
        return NSError(domain: domain, code: code, userInfo: ["message": message, "meta": meta])
    }
    
    static func log(error err: NSError) {
        Crashlytics.sharedInstance().recordError(err)
    }
    
    static func log(error err: Error) {
        Crashlytics.sharedInstance().recordError(err)
    }
    
    static func processError(err: Error) {
        let message = (err is FlashcardError) ? (err as! FlashcardError).message : err.localizedDescription
        StatusBar.display(message: message)
        FlashcardError.log(error: err)
    }
}

