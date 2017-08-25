//
//  NewDeckFormController.swift
//  Flashcard
//
//  Created by Eli Gregory on 7/30/17.
//  Copyright © 2017 Eli Gregory. All rights reserved.
//

import Foundation
import Eureka
import Alamofire
import PKHUD
import then

class NewDeckFormController: FormViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let header = Section("Deck")
        
        let nameRow = TextRow() { row in
            row.placeholder = "Name"
            row.add(rule: RuleRequired())
            row.tag = Deck.keys.name
            row.onChange { row in
                if let value = row.value {
                    row.value = value.capitalized
                }
            }
        }
        
        let submitButton = ButtonRow() { row in
            row.title = "Submit"
            row.onCellSelection({ _ , row in
                
                let validations = self.form.validate()
                
                guard validations.count < 1 else {
                    self.present(alert: validations[0].msg)
                    return
                }
                
                guard let name = self.form.values()[Deck.keys.name] as? String else {
                    self.present(alert: "Not a proper name!")
                    return
                }
                
                self.showProgress()
                
                Deck.new(deck: name)
                    .then(Deck.addLocal)
                    .then({ deck  in
                        Session.deck = deck
                        self.navigationController?.popViewController(animated: true)
                    })
                    .onError(FlashcardError.processError)
                    .finally({
                        self.hideProgress()
                    })
                
                
//                Deck.new(deck: name).then { deck in
//                        Session.deck = deck
//                        self.navigationController?.popViewController(animated: true)
//                    }
//                    .onError { err in
//                        StatusBar.display(message: err.userErrorMessage)
//                        FlashcardError.log(error: err)
//                    }
//                    .finally {
//                        PKHUD.sharedHUD.hide()
//                }
            })
        }
        
        form +++ header <<< nameRow <<< submitButton
    }
}

