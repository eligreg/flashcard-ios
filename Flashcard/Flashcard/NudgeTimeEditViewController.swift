//
//  NudgeTimeEditViewController.swift
//  Flashcard
//
//  Created by Eli Gregory on 7/31/17.
//  Copyright © 2017 Eli Gregory. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class NudgeTimeEditViewController: UIViewController {
    
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var ring: Nudge?
    
    override func viewWillAppear(_ animated: Bool) {
        if let time = ring?.time as Date? {
            self.timePicker.date = time
        }
        
        saveButton.isEnabled = true
        
        self.title = ring != nil ? "Edit Time" : "New Time"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    @IBAction func userDeletesRing( _ sender: Any) {
        do {
            let realm = try Realm()
            try realm.write {
                if let r = self.ring {
                    r.time = timePicker.date as NSDate
                }
                else {
                    let r = Nudge()
                    r.time = timePicker.date as NSDate
                    realm.add(r)
                }
            }
        }
        catch let error as NSError {
            print(error)
        }

        self.navigationController?.popViewController(animated: true)
    }
}
