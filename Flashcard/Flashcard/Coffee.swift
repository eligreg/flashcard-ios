//
//  Coffee.swift
//  Flashcard
//
//  Created by Eli Gregory on 8/11/17.
//  Copyright © 2017 Eli Gregory. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyTimer

// This class exists purely because i'll be using the free tier of Heroku's plans and I want to keep the server awake.

class Coffee {
    
    fileprivate var timer: Timer?
    fileprivate var request: Request?
    
    fileprivate static var shared = Coffee()
    
    static func start() {
        shared.sip()
        shared.timer = Timer.every(90.seconds) {
            shared.sip()
        }
    }
    
    static func sip() {
        print("Background Coffee Sip")
        shared.sip()
    }
    
    fileprivate func sip() {
        self.request = Alamofire.request( Routes.wake() )
            .responseJSON(completionHandler: { (response) in
                if let err = response.error {
                    print("Server Error \(err)")
                    return
                }
                guard let json = response.json else {
                    print("Invalid JSON")
                    return
                }
                if json["awake"] as? Bool == true {
                    print("Woke")
                }
            })
    }
    
    static func stop() {
        shared.timer?.invalidate()
        shared.timer = nil
        shared.request?.cancel()
        shared.request = nil
    }
}
