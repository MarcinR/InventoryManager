//
//  DatabaseItem.swift
//  Inventory Manager
//
//  Created by Marcin Ratajczak on 15/04/2022.
//  Copyright © 2022 A. All rights reserved.
//

import Foundation

struct DatabaseItem: Identifiable, Codable {
    let id: String
    let item: InventoryItem
}
