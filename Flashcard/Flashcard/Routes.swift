//
//  Routes.swift
//  Flashcard
//
//  Created by Eli Gregory on 7/23/17.
//  Copyright © 2017 Eli Gregory. All rights reserved.
//

import Foundation
import Alamofire

public struct API {
    static let base: String = Secrets.baseURL
}

public enum Routes: URLRequestConvertible {

    case wake()
    case decksList()
    case decksNew(name: String)
    case decksCards(id: Int)
    case decksUpdate(id: Int, name: String)
    case cardsNew(deck_id: Int, front: String, back: String)
    case cardsUpdate(id: Int, front: String, back: String)
    case cardsDelete()
    
    var api: String { return "" }
    var decks: String { return api + "/decks" }
    var cards: String { return api + "/cards" }
    
    var path: String {
        switch self {
        case .wake(): return api
        case .decksList(): return decks
        case .decksNew(_): return decks
        case .decksCards(let id): return decks + "/\(id)"
        case .decksUpdate(let id, _): return decks + "/\(id)"
        case .cardsNew(_,_,_): return cards
        case .cardsUpdate(let id,_,_): return cards + "/\(id)"
        case .cardsDelete(let id): return cards + "/\(id)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .wake(): return .get
        case .decksList(): return .get
        case .decksCards(_): return .get
        case .decksNew(_): return .post
        case .cardsNew(_,_,_): return .post
        case .decksUpdate(_,_): return .patch
        case .cardsUpdate(_,_,_): return .patch
        case .cardsDelete(_): return .delete
        }
    }
    
    var headers: HTTPHeaders {
        return [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "X-Token": Secrets.requestToken ?? "failed_token"
        ]
    }
    
    var body: Data? {
        switch self {
        case .decksNew(let name):
            return try? JSONSerialization.data(withJSONObject: [Deck.keys.name: name])
        case .decksUpdate(_,let name):
            return try? JSONSerialization.data(withJSONObject: [Deck.keys.name: name])
        case .cardsNew(let deck_id, let front,let back):
            return try? JSONSerialization.data(withJSONObject: [Card.keys.deck_id: deck_id, Card.keys.front: front, Card.keys.back: back])
        case .cardsUpdate(_, let front, let back):
            return try? JSONSerialization.data(withJSONObject: [Card.keys.front: front, Card.keys.back: back])
        default: return nil
        }
    }
    
    public func asURLRequest() throws -> URLRequest {
        let url = try API.base.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        
        urlRequest.httpMethod = method.rawValue
        
        for (k, v) in headers {
            urlRequest.addValue(v, forHTTPHeaderField: k)
        }
        
        urlRequest.httpBody = body
        
        return urlRequest
    }
}
