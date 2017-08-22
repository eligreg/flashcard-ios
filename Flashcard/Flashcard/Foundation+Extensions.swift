//
//  Foundation+Extensions.swift
//  Flashcard
//
//  Created by Eli Gregory on 8/19/17.
//  Copyright © 2017 Eli Gregory. All rights reserved.
//

import Foundation

func randomInt(min: Int, max: Int) -> Int {
    return min + Int(arc4random_uniform(UInt32(max - min + 1)))
}

func randomDouble(min: Double, max: Double) -> Double {
    return (Double(arc4random()) / 0xFFFFFFFF) * (max - min) + min
}
