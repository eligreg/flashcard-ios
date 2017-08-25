//
//  Alamofire+Extensions.swift
//  Flashcard
//
//  Created by Eli Gregory on 7/29/17.
//  Copyright © 2017 Eli Gregory. All rights reserved.
//

import Foundation
import Alamofire
import Gloss

extension DataResponse {
    
    var resourceIsMissing: Bool {
        guard let resp = self.response else {
            return false
        }
        return resp.statusCode == 404
    }
    
    var forbidden: Bool {
        guard let resp = self.response else {
            return false
        }
        return resp.statusCode == 403
    }
    
    var json: JSON? {
        get {
            return self.result.value as? JSON
        }
    }
    
    var jsonArray: [JSON]? {
        get {
            return self.result.value as? [JSON]
        }
    }
}

