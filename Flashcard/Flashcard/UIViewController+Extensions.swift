//
//  UIViewController+Extensions.swift
//  Flashcard
//
//  Created by Eli Gregory on 8/7/17.
//  Copyright © 2017 Eli Gregory. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func present(alert message: String?, completion: (()->Void)? = nil) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction) in completion?() }
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
}
