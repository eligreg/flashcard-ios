//
//  ChooseDeckViewController.swift
//  Flashcard
//
//  Created by Eli Gregory on 7/30/17.
//  Copyright © 2017 Eli Gregory. All rights reserved.
//

import Foundation
import UIKit
import PKHUD
import RealmSwift

class ChooseDeckViewController: UITableViewController {
    
    var decks: [Deck]?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.showProgress()
        
        // TODO RECOVER STATEMENTS?
        Deck.getAllRemote()
            .then(Deck.synchronizeAllLocal)
            .then ({ decks in
                self.decks = decks
                self.tableView.reloadData()
            })
            .onError(FlashcardError.processError)
            .finally({
                self.hideProgress()
            })
    }
    
    // MARK Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Session.deck = decks?[indexPath.row]
        Session.pushDeck()
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK Datasource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return decks?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "chooseDeckTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) ??
            UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: cellIdentifier)
        
        guard let deck = decks?[indexPath.row] else {
            return cell
        }

        cell.textLabel?.text = deck.name
        cell.detailTextLabel?.text = "(\(deck.cardsCount)) card" + ((Int(deck.cardsCount) == 0 || Int(deck.cardsCount) > 1) ? "s" : "")
        
        return cell
    }
}
