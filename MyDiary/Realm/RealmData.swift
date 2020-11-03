//
//  RealmData.swift
//  Numbertank
//
//  Created by Manan Sheth on 03/07/17.
//  Copyright © 2017 Manan Sheth. All rights reserved.
//

import UIKit
import RealmSwift

let appRealmVersion = 1

class RealmData: NSObject {
    
    class func realmConfigForSharedContainer(realmName: String) -> Realm.Configuration {
        
        var config = Realm.Configuration(shouldCompactOnLaunch: { totalBytes, usedBytes in
            // totalBytes refers to the size of the file on disk in bytes (data + free space)
            // usedBytes refers to the number of bytes used by data in the file
            
            // Compact if the file is over 20MB in size and less than 50% 'used'
            
            IBPrint("Realm : Total Bytes =================== \(totalBytes)")
            
            let twentyMB = 20 * 1024 * 1024
            return (totalBytes > twentyMB) && (Double(usedBytes) / Double(totalBytes)) < 0.5
        })
        //config.fileURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: NTAppUtils.returnGroupID())?.appendingPathComponent("Library/\(realmname).realm")
        config.deleteRealmIfMigrationNeeded = false
        config.schemaVersion = UInt64(appRealmVersion)
        config.migrationBlock = getMigrationBlock()
        return config
    }
    
    class func realmDefaultConfig(realmName: String) {
        
        var config = Realm.Configuration(shouldCompactOnLaunch: { totalBytes, usedBytes in
            // totalBytes refers to the size of the file on disk in bytes (data + free space)
            // usedBytes refers to the number of bytes used by data in the file
            
            // Compact if the file is over 20MB in size and less than 50% 'used'
            IBPrint("Realm : Total Bytes =================== \(totalBytes)")
            
            let twentyMB = 20 * 1024 * 1024
            return (totalBytes > twentyMB) && (Double(usedBytes) / Double(totalBytes)) < 0.5
        })
        config.fileURL = config.fileURL?.deletingLastPathComponent().appendingPathComponent("\(realmName).realm")
        IBPrint("Realm URL : \(config.fileURL!)")
        config.deleteRealmIfMigrationNeeded = false
        config.schemaVersion = UInt64(appRealmVersion)
        config.migrationBlock = getMigrationBlock()
        Realm.Configuration.defaultConfiguration = config
    }
    
    class func clearAllFilesFromDirectory(isLibrary: Bool) {
        
        let fileManager = FileManager.default
        let paths = isLibrary ?
            NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true) :
            NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        
        guard let dirPath = paths.first else {
            return
        }
        
        let folderList = try! fileManager.contentsOfDirectory(atPath: dirPath)
        for folder in folderList {
            
            do {
                let folderPath: String = URL(fileURLWithPath: dirPath).appendingPathComponent(folder).path
                try fileManager.removeItem(atPath: folderPath)
            }
            catch {
                IBPrint("Could not retrieve directory: \(error)")
            }
        }
    }
    
    class func getMigrationBlock() -> MigrationBlock {
        
        return {(_ migration: Migration, oldSchemaVersion: UInt64) -> Void in
            
            if oldSchemaVersion < UInt64(appRealmVersion)
            {
                var oldVersion = oldSchemaVersion
                
                
                //Load App Tour Data
            }
            IBPrint("Migration completed.")
        }
    }
    
    
    
}
