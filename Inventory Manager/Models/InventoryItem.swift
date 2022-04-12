//
//  InventoryItem.swift
//  Inventory Manager
//
//  Created by Marcin Ratajczak on 20/09/2019.
//  Copyright © 2019 A. All rights reserved.
//

import Foundation

struct InventoryItem: Identifiable, Codable {
    let id: String?
    let code: String
    let name: String
    let shelfID: String?
    let description: String?
}
