//
//  Routes.swift
//  Flashcard
//
//  Created by Eli Gregory on 7/23/17.
//  Copyright © 2017 Eli Gregory. All rights reserved.
//

import Foundation
import Alamofire

public enum Routes: URLRequestConvertible {

    case decksList()
    case decksNew()
    case decksCards()
    case decksUpdate()
    case cardsNew()
    case cardsUpdate()
    case cardsDelete()
    
    var api: String { return "" }
    var decks: String { return api + "/decks" }
    var cards: String { return api + "/cards" }
    
    var path: String {
        switch self {
        case .decksList(), .decksNew(): return decks
        case .decksCards(let id), .decksUpdate(let id): return decks + "/\(id)"
        case .cardsNew(): return cards
        case .cardsUpdate(let id), .cardsDelete(let id): return cards + "/\(id)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .decksList(), .decksCards(): return .get
        case .decksNew(), .cardsNew(): return .post
        case .decksUpdate(), .cardsUpdate(): return .patch
        case .cardsDelete(): return .delete
        }
    }
    
    var headers: HTTPHeaders {
        return ["Content-Type": "application/json", "Accept": "application/json"]
    }
    
    var body: Data? {
        // TODO: Serialize JSON
        return nil
    }
    
    public func asURLRequest() throws -> URLRequest {
        let url = try "localhost".asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        
        urlRequest.httpMethod = method.rawValue
        
        for (k, v) in headers {
            urlRequest.addValue(v, forHTTPHeaderField: k)
        }
        
        urlRequest.httpBody = body
        
        return urlRequest
    }
}
