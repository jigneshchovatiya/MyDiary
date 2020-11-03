//
//  Realm+Helper.swift
//  Numbertank
//
//  Created by Manan Sheth on 04/07/17.
//  Copyright © 2017 Manan Sheth. All rights reserved.
//

import UIKit
import RealmSwift

extension Realm {
    
    private func safeTransaction(withBlock block: @escaping () -> Void) {
        
        if !isInWriteTransaction {
            beginWrite()
        }
        
        block()
        
        if isInWriteTransaction {
            do {
                try commitWrite()
            }
            catch {
                IBPrint(error.localizedDescription)
            }
        }
    }
    
    //NSPredicate(format: "featuretype > 0")
    //[SortDescriptor(keyPath: "Author", ascending: true), SortDescriptor(keyPath: "Title", ascending: true)
    func fetchObjects<T: Object>(type: T.Type, predicate: NSPredicate?, order: [SortDescriptor]?) -> Results<T>? {
        
        var results = objects(type)
        
        if predicate != nil {
            results = results.filter(predicate!)
        }
        if order != nil {
            results = results.sorted(by: order!)
        }
        return results
    }
    
    func fetchFirstObject<T: Object>(type: T.Type, predicate: NSPredicate?, order: [SortDescriptor]?) -> T? {
        
        var results = objects(type)
        
        if predicate != nil {
            results = results.filter(predicate!)
        }
        if order != nil {
            results = results.sorted(by: order!)
        }
        return results.first
    }
    
    func addObject(object: Object?, update: UpdatePolicy? = .all) {
        
        safeTransaction { 
            if object != nil
            {
                self.add(object!, update: update!)
            }
        }
    }
    
    func addAllObjects<T: Object>(list: [T]?, update: UpdatePolicy? = .all) {
        
        safeTransaction { 
            self.add(list!, update: update!)
        }
    }
    
    func updateObject(updateBlock: @escaping () -> ()) {
        
        safeTransaction { 
            updateBlock()
        }
    }
    
    func deleteObject(object: Object?) {
        
        safeTransaction { 
            if object != nil {
                self.delete(object!)
            }
        }
    }
}
