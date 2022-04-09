//
//  DatabaseService.swift
//  Inventory Manager
//
//  Created by Marcin Ratajczak on 20/09/2019.
//  Copyright © 2019 A. All rights reserved.
//

import Foundation
import FirebaseDatabase

protocol DatabaseService {
    func getItemsWithCode( code: String) -> [InventoryItem]
    func getShelfsWithCode( code: String) -> [Shelf]
    func addInventoryItem( item: InventoryItem)
    func addShelf( shelf: Shelf)
}

class DatabaseServiceImp: DatabaseService {
    
    private let database = Database.database()
    private let uid: String!
    private let encoder = JSONEncoder()
    
    init(uid: String) {
        database.isPersistenceEnabled = true
        self.uid = uid
    }
    
    private lazy var itemsRef: DatabaseReference = {
            return database.reference()
            .child("\(String(describing: uid))/items")
    }()
    
//    func getItemsWithBarcode(_ barcode: String) -> [InventoryItem] {
//        let child =  dbReference.child("Items")
//        guard
//            let id = child.key,
//            let name = child.value(forKey: "name") as? String,
//            let shelfID = child.value(forKey: "shelfID") as? String
//            else { return [] }
//
//        let item = InventoryItem(
//            id: barcode,
//            code: child.value(forKey: "code") as? String,
//            name: name,
//            shelfID: shelfID,
//            description: child.value(forKey: "description") as? String
//        )
//        return [item]
//    }
    
    func getItemsWithCode(barcode: String) -> [InventoryItem] {
        return []
    }
    
    
    // TODO: obsłużyć error
    func addInventoryItem(item: InventoryItem) {
        do {
          let data = try encoder.encode(thought)
          let json = try JSONSerialization.jsonObject(with: data)
          databasePath.childByAutoId()
            .setValue(json)
        } catch {
          print("an error occurred", error)
        }
    }
    
    func addShelf(shelf: Shelf) {
        
    }
    
    func getShelfsWithCode(code: String) -> [Shelf] {
        return []
    }
    
    
}
