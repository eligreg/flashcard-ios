//
//  RootTableViewController.swift
//  Flashcard
//
//  Created by Eli Gregory on 7/29/17.
//  Copyright © 2017 Eli Gregory. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class RootTableViewController: UITableViewController {
    
    typealias Action = ()->Void
    
    enum Index: Int {
        case deckActivity = 0
        case nudges = 1
        
        static var all: [Index] {
            return [.deckActivity, .nudges]
        }
        
        static var count: Int {
            return all.count
        }
        
        var header: String {
            switch self {
            case .deckActivity:
                return Session.deck != nil ? "(\(Session.deck!.name))" : "Deck"
            case .nudges:
                return "Nudges"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(Realm.Configuration.defaultConfiguration.fileURL!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.reloadData()
        
        if Session.shouldPushDeck {
            self.performSegue(withIdentifier: "rootTableToDeckView", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let ringEditor = segue.destination as? NudgeTimeEditViewController, let ring = sender as? Nudge {
            ringEditor.ring = ring
        }
    }
    
    // MARK Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case Index.deckActivity.rawValue:
            performSegue(withIdentifier: DeckActivity.item(forIndexPath: indexPath).segue, sender: self)
        case Index.nudges.rawValue:
            performSegue(withIdentifier: Nudges.segue, sender: Nudges.item(forIndexPath: indexPath))
        default:
            return
        }
    }
    
    // MARK Datasource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return Index.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case Index.deckActivity.rawValue:
            return DeckActivity.rows
        case Index.nudges.rawValue:
            return Nudges.rows + 1
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView:UITableView, titleForHeaderInSection section: Int) -> String? {
        return Index(rawValue: section)?.header ?? ""
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
            
        case Index.deckActivity.rawValue:
            let cellIdentifier = "DeckActivityTableViewCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) ??
                UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: cellIdentifier)
            let item = DeckActivity.item(forIndexPath: indexPath)
            cell.textLabel?.text = item.title
            return cell
            
        case Index.nudges.rawValue:
            if Nudges.within(indexPath) {
                let cellIdentifier = "NudgesTableViewCell"
                let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) ??
                    UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: cellIdentifier)
                let item = Nudges.item(forIndexPath: indexPath)
                cell.textLabel?.text = item?.description
                return cell
            }
            else {
                let cellIdentifier = "NewNudgeTableViewCell"
                let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) ??
                    UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: cellIdentifier)
                cell.textLabel?.text = "New Nudge"
                return cell
            }
        default:
            return UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "fake")
        }


    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        guard indexPath.section == Index.nudges.rawValue else {
            return false
        }
        return Nudges.within(indexPath)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            do {
                try Nudges.delete(itemAtIndexPath: indexPath)
                self.tableView.deleteRows(at: [indexPath], with: .fade)
            }
            catch let error as NSError {
                self.present(alert: "There was an error deleting the Nudge: \(error)")
            }
        }
    }
}
