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
    func getItemsWithBarcode(_ barcode: String) -> [InventoryItem]
    func getShelfsWithBarcode(_ barcode: String) -> [Shelf]
    func addInventoryItem(_ item: InventoryItem)
    func addShelf(_ shelf: Shelf)
}
///!@#$  na szybko uzupełnione żeby odpalić,  poprawić tę funkcję
struct DatabaseServiceImp: DatabaseService {
    func getItemsWithBarcode(_ barcode: String) -> [InventoryItem] {
        let child =  dbReference.child("Items")
        guard
            let id = child.key,
            let name = child.value(forKey: "name") as? String,
            let shelfID = child.value(forKey: "shelfID") as? String
            else { return [] }
        
        let item = InventoryItem(
            id: barcode,
            code: child.value(forKey: "code") as? String,
            name: name,
            shelfID: shelfID,
            description: child.value(forKey: "description") as? String
        )
        return [item]
    }
    
    func addInventoryItem(_ item: InventoryItem) {
    }
    
    func addShelf(_ shelf: Shelf) {
        
    }
    
    func getShelfsWithBarcode(_ barcode: String) -> [Shelf] {
        return []
    }
    
    private var dbReference = Database.database().reference()
    
}
