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
    case success([InventoryItem]?)
    case error(Error)
}

protocol DatabaseService {
    func searchItemsWithCode( code: String, completion: @escaping (DatabaseActionResult)->())
    func addInventoryItem( item: InventoryItem, completion: @escaping (DatabaseActionResult)->())
//    func addLocation( location: InventoryLocation, completion: @escaping (DatabaseActionResult)->())
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
            return databaseReference.child(uid + "/items")
    }()
    
    private lazy var locationsRef: DatabaseReference = {
            return databaseReference.child(uid + "/locations")
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
//    func addLocation(location: InventoryLocation, completion: @escaping (DatabaseActionResult) -> ()) {
//        do {
//            let data = try encoder.encode(location)
//            let json = try JSONSerialization.jsonObject(with: data)
//            itemsRef.childByAutoId().setValue(json)
//            completion(.success(nil))
//        } catch {
//            completion(.error(error))
//        }
//    }
    
    func searchItemsWithCode( code: String,  completion: @escaping (DatabaseActionResult)->()) {
        itemsRef.queryOrdered(byChild: CodeDBKey).queryEqual(toValue: code).observeSingleEvent(of: .value) { snapshot in
            var items: [InventoryItem] = []
            for child in snapshot.children {
                print(child)
                do {
                    let childSnapshot = child as! DataSnapshot
                    let data = try JSONSerialization.data(withJSONObject: childSnapshot.value!)
                    let item = try self.decoder.decode(InventoryItem.self, from: data)
                    items.append(item)
                } catch {
                    print("an error occurred", error)
                }
            }
            completion(.success(items))
        }
    }
    
    
//    func searchLocationsWithCode( code: String, completion: @escaping (DatabaseActionResult)->()) {
//        locationsRef.queryOrdered(byChild: CodeDBKey).queryEqual(toValue: code).observeSingleEvent(of: .value) { snapshot in
//            var locations: [InventoryLocation] = []
//            for child in snapshot.children {
//                print(child)
//                do {
//                     let childSnapshot = child as! DataSnapshot
//                    let data = try JSONSerialization.data(withJSONObject: childSnapshot.value!)
//                    let item = try self.decoder.decode(InventoryLocation.self, from: data)
//                    locations.append(item)
//                } catch {
//                    print("an error occurred", error)
//                }
//            }
//            completion(.success([]))
//        }
//    }
    
    
}
