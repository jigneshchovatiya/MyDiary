//
//  objNotes.swift
//  iBackup
//
//  Created by Apple on 02/11/20.
//

import UIKit
import RealmSwift

class objNotes: Object
{
    @objc dynamic var notesID: String = ""
    @objc dynamic var updatedat: Double = 0
    @objc dynamic var title: String = ""
    @objc dynamic var desc: String = ""
    
    var _safecopy: objNotes?
    
    override class func primaryKey() -> String {
        return "notesID"
    }
    
    override class func ignoredProperties() -> [String] {
        return ["_safecopy"]
    }
    
    var safecopy: objNotes {
           
           if _safecopy == nil {
               _safecopy = objNotes(value: self)
           }
           return _safecopy!
       }
    
    convenience init(dictionary: NSDictionary) {
        self.init()
        mapWithDictionary(dictionary: dictionary)
    }
    
    func mapWithDictionary(dictionary: NSDictionary) {
        
        if dictionary["notesID"] != nil && !(dictionary["notesID"] is NSNull) {
            notesID = "\(dictionary["notesID"]!)"
        }
        
        if dictionary["updatedat"] != nil && !(dictionary["updatedat"] is NSNull) {
            updatedat = (dictionary["updatedat"] as? Double)!
        }
        
        if dictionary["title"] != nil && !(dictionary["title"] is NSNull) {
            title = "\(dictionary["title"]!)"
        }
        
        if dictionary["desc"] != nil && !(dictionary["desc"] is NSNull) {
            desc = "\(dictionary["title"]!)"
        }
    }
}
