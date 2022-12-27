//
//  DatabaseService.swift
//  Inventory Manager
//
//  Created by Marcin Ratajczak on 20/09/2019.
//  Copyright © 2019 A. All rights reserved.
//

import Foundation
import FirebaseDatabase

enum DatabaseActionResult {
    case success([DatabaseItem]?)
    case error(Error)
}

protocol DatabaseService {
    func searchItemsWithCode( code: String, completion: @escaping (DatabaseActionResult)->())
    func addInventoryItem( item: InventoryItem, completion: @escaping (DatabaseActionResult)->())
    func updateItem(item: DatabaseItem, completion: @escaping (DatabaseActionResult)->())
    func deleteItem(withID id: String, completion: @escaping (DatabaseActionResult)->())
    func searchItemsWithText(text: String,  completion: @escaping (DatabaseActionResult)->())
    func searchItemsInLocation(withID locationID: String,  completion: @escaping (DatabaseActionResult)->())
}

class DatabaseServiceImp: DatabaseService {
    private let CodeDBKey = "code"
    private let databaseReference = Database.database().reference()
    private let uid: String!
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    init(uid: String) {
        self.uid = uid
    }
    
    private lazy var itemsRef: DatabaseReference = {
        let ref = databaseReference.child(uid + "/items")
        ref.keepSynced(true)
        return ref
    }()
    
    
    func addInventoryItem(item: InventoryItem, completion: @escaping (DatabaseActionResult)->()) {
        do {
          let data = try encoder.encode(item)
          let json = try JSONSerialization.jsonObject(with: data)
          itemsRef.childByAutoId().setValue(json)
            completion(.success(nil))
        } catch {
            completion(.error(error))
        }
    }
    
    
    func updateItem(item: DatabaseItem, completion: @escaping (DatabaseActionResult)->()) {
        do {
            let data = try encoder.encode(item.item)
          let json = try JSONSerialization.jsonObject(with: data)
            itemsRef.child(item.id).setValue(json)
            completion(.success(nil))
        } catch {
            completion(.error(error))
        }
    }
    
    func searchItemsWithCode( code: String,  completion: @escaping (DatabaseActionResult)->()) {
        itemsRef.queryOrdered(byChild: CodeDBKey).queryEqual(toValue: code).observeSingleEvent(of: .value) { snapshot in
            var items: [DatabaseItem] = []
            for child in snapshot.children {
                do {
                    let childSnapshot = child as! DataSnapshot
                    let data = try JSONSerialization.data(withJSONObject: childSnapshot.value!)
                    let item = try self.decoder.decode(InventoryItem.self, from: data)
                    items.append(DatabaseItem(id: childSnapshot.key, item: item))
                } catch {
                    print("an error occurred", error)
                }
            }
            completion(.success(items))
        }
    }
    
    func deleteItem(withID id: String, completion: @escaping (DatabaseActionResult)->()) {
        itemsRef.child(id).removeValue { error, _ in
            if let error = error {
                completion(.error(error))
            } else {
                completion(.success(nil))
            }
        }
    }
    
    
    func searchItemsWithText(text: String,  completion: @escaping (DatabaseActionResult)->()) {
        itemsRef.observeSingleEvent(of: .value) { snapshot in
            var databaseItems: [DatabaseItem] = []
            let query = text.lowercased()
            guard let snapshotDictionary = snapshot.value as? [String: AnyObject] else { return }
            for element in snapshotDictionary {
                // check if 
                guard let name = element.value["name"] as? String,
                      let description = element.value["description"] as? String,
                      (name.lowercased().contains(query) || description.lowercased().contains(query))
                else { continue }
                
                do {
                    let data = try JSONSerialization.data(withJSONObject: element.value)
                    let item = try self.decoder.decode(InventoryItem.self, from: data)
                    databaseItems.append(DatabaseItem(id: element.key, item: item))
                } catch {
                    print("an error occurred", error)
                }
            }
            completion(.success(databaseItems))
        }
    }

    func searchItemsInLocation(withID locationID: String,  completion: @escaping (DatabaseActionResult)->()) {
        // TODO: przepisać to aby nie brać wszystkich snapshotów tylko wyszukiwać po Items/item/shelfID
        itemsRef.observeSingleEvent(of: .value) { snapshot in
            var databaseItems: [DatabaseItem] = []
            guard let snapshotDictionary = snapshot.value as? [String: AnyObject] else { return }
            for element in snapshotDictionary {

                guard let shelf = element.value["shelfID"] as? String,
                      shelf == locationID
                else { continue }

                do {
                    let data = try JSONSerialization.data(withJSONObject: element.value)
                    let item = try self.decoder.decode(InventoryItem.self, from: data)
                    databaseItems.append(DatabaseItem(id: element.key, item: item))
                } catch {
                    print("an error occurred", error)
                }
            }
            completion(.success(databaseItems))
        }
    }
}
