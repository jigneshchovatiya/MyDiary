//
//  ViewController.swift
//  MyDairy
//
//  Created by Apple on 02/11/20.
//

import UIKit
import RealmSwift
import AsyncDisplayKit

class ViewController: UIViewController {

    
    var objectNotesArray : Results<objNotes>?
    var mainRealm = try! Realm()
    var newNotesObject = [objNotes]()
    var _notificationToken: NotificationToken? = nil
    let tblContainerNode: ASTableNode = ASTableNode()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.title = "My Diary"
        objectNotesArray = mainRealm.fetchObjects(type: objNotes.self, predicate: nil, order:[SortDescriptor(keyPath: "updatedat", ascending: false)])!
        if objectNotesArray?.count == 0
        {
            if let path = Bundle.main.path(forResource: "source", ofType: "json")
            {
                do
                {
                    let data: Data = try Data(contentsOf: URL(fileURLWithPath: path), options: Data.ReadingOptions.alwaysMapped)
                    let dataDict = try JSONSerialization.jsonObject(with: data, options: []) as! [NSDictionary]
                    
                    for dict in dataDict
                    {
                        let object = objNotes()
                        object.desc = dict.value(forKey: "content") as! String
                        object.title = dict.value(forKey: "title") as! String
                        object.updatedat = dict.value(forKey: "date") as! Double
                        object.notesID = dict.value(forKey: "id") as! String
                        newNotesObject.append(object)
                    }
                    self.mainRealm.beginWrite()
                    self.mainRealm.add(self.newNotesObject, update: .all)
                    try! self.mainRealm.commitWrite()
                    objectNotesArray = mainRealm.fetchObjects(type: objNotes.self, predicate: nil, order:[SortDescriptor(keyPath: "updatedat", ascending: false)])!
                    fetchObjectAndReloadData()
                }
                catch
                {
                    
                }
            }
        }
        fetchObjectAndReloadData()
    }
    
    func addRealmNotification()
    {
        if _notificationToken != nil {
            _notificationToken?.invalidate()
            _notificationToken = nil
        }
        
        //Notification
        _notificationToken = objectNotesArray?.observe({(changes: RealmCollectionChange) -> Void in
            
            switch changes
            {
            
            
            case .error(let error):
                print("error===\(error)")
                break
                
            case .initial(_):
                //self.node.reloadData()
                break
                
            case .update( _, deletions: let delete, insertions: let insert, modifications: let modification):
                
                self.tblContainerNode.performBatch(animated: true, updates:
                                                    {
                                                        self.tblContainerNode.insertRows(at: insert.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                                                        
                                                        if delete.count > 0
                                                        {
                                                            self.tblContainerNode.reloadData()
                                                        }
                                                        self.tblContainerNode.reloadRows(at: modification.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                                                    })
                { (compete) in
                    
                }
                break
            }
        })
    }
    
    func configureScrollView() {
        
        self.addRealmNotification()
        
        view.addSubview(tblContainerNode.view)
        tblContainerNode.delegate = self
        tblContainerNode.dataSource = self
        tblContainerNode.view.separatorStyle = .none
        tblContainerNode.view.tableFooterView = nil
        tblContainerNode.view.keyboardDismissMode = .interactive
        tblContainerNode.view.backgroundColor = CommonClass.AppColor.appWhiteColor
        tblContainerNode.view.frame.size.width = view.bounds.size.width
        tblContainerNode.view.frame.size.height = view.bounds.size.height - (CommonClass.IsiPhoneX() ? 20 : 0)
        tblContainerNode.allowsMultipleSelectionDuringEditing = true
        tblContainerNode.clipsToBounds = true
    }
    
    func fetchObjectAndReloadData()
    {
        configureScrollView()
    }
}

extension ViewController : ASTableDelegate,ASTableDataSource
{
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 1
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int
    {
        return objectNotesArray!.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        
        //Card Node
        let object = objectNotesArray![indexPath.row].safecopy
        
        if indexPath.row == 0
        {
            let nodeBlock: ASCellNodeBlock =
            {
                let node = notesNode.init(rootViewController: self, notesObject: object, previousObj: nil, indexPathRow:indexPath, token: nil)
                node.selectionStyle = .none
                return node
            }
            return nodeBlock
        }
        else
        {
            let preObject = objectNotesArray![indexPath.row-1].safecopy
            let nodeBlock: ASCellNodeBlock =
            {
                let node = notesNode.init(rootViewController: self, notesObject: object, previousObj: preObject, indexPathRow:indexPath, token: nil)
                node.selectionStyle = .none
                return node
            }
            return nodeBlock
        }
    }
    
}

