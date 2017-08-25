//
//  NewCardFormController.swift
//  Flashcard
//
//  Created by Eli Gregory on 7/31/17.
//  Copyright © 2017 Eli Gregory. All rights reserved.
//

import Foundation
import Eureka
import Alamofire
import PKHUD

class NewCardFormController: FormViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let header = Section("Card")
        
        let frontText = TextRow() { row in
            row.placeholder = "Front Text"
            row.tag = Card.keys.front
            row.add(rule: RuleRequired())
        }
        
        let backText = TextRow() { row in
            row.placeholder = "Back Text"
            row.tag = Card.keys.back
            row.add(rule: RuleRequired())
        }
        
        let submitButton = ButtonRow() { row in
            row.title = "Submit"
            row.onCellSelection({ _ , row in
                
                let validations = self.form.validate()
                
                guard validations.count < 1 else {
                    self.present(alert: "Missing (\(validations.count)) fields!")
                    return
                }
                
                guard let front = self.form.values()[Card.keys.front] as? String else {
                    self.present(alert: "Missing front value!")
                    return
                }
                
                guard let back = self.form.values()[Card.keys.back] as? String else {
                    self.present(alert: "Missing back value!")
                    return
                }
                
                guard Session.deck != nil else {
                    self.present(alert: "No Deck to assign this card to!") { self.dismiss(animated: true, completion: nil) }
                    return
                }
                
                self.showProgress()
                
                if let deck = Session.deck {
                    
                    deck.newRemoteCard(front: front, back: back)
                        .then(Card.addUpdateLocal)
                        .then(deck.insertLocal)
                        .onError(FlashcardError.processError)
                        .finally({
                            self.hideProgress()
                            self.dismiss(animated: true, completion: nil)
                        })

                    
//                    Deck.new(cardForDeck: deck, front: front, back: back)
//                        .then(Card.add)
//                        .then(Deck.insertLocal)
//                        .onError(FlashcardError.processError)
//                        .finally({
//                            self.hideProgress()
//                            self.dismiss(animated: true, completion: nil)
//                        })
                }
            })
        }
        
        form +++ header <<< frontText <<< backText <<< submitButton
    }
    
    @IBAction func userDidTapCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
