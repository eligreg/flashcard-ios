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
