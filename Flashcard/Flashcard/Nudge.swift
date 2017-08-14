//
//  Nudge.swift
//  Flashcard
//
//  Created by Eli Gregory on 7/31/17.
//  Copyright © 2017 Eli Gregory. All rights reserved.
//

import Foundation
import RealmSwift

class Nudge: Object {
    
    dynamic var time: NSDate = NSDate()
    
    override var description: String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.autoupdatingCurrent
        formatter.timeStyle = .short
        return formatter.string(from: self.time as Date)
    }
}

struct Nudges {
    
    static var results: Results<Nudge>?  {
        do {
            let realm = try Realm()
            return realm.objects(Nudge.self).sorted(byKeyPath: "time", ascending: true)
        }
        catch {
            print("Error with Realm")
            return nil
        }
    }
    
    static var rows: Int {
        return results?.count ?? 0
    }
    
    static func item(forIndexPath indexPath: IndexPath) -> Nudge? {
        guard within(indexPath), let nudges = results else {
            return nil
        }
        return nudges[indexPath.row]
    }
    
    static func delete(itemAtIndexPath indexPath: IndexPath) throws {
        guard let nudge = item(forIndexPath: indexPath) else {
            return
        }
        let realm = try Realm()
        try realm.write {
            realm.delete(nudge)
        }
    }
    
    static var segue: String {
        return "rootTableToTimeEditor"
    }
    
    static func within(_ indexPath: IndexPath) -> Bool {
        return indexPath.row <= rows - 1
    }
}
