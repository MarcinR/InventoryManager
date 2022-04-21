//
//  BarcodeMonsterDetails.swift
//  Inventory Manager
//
//  Created by Marcin Ratajczak on 13/04/2022.
//  Copyright © 2022 A. All rights reserved.
//

import Foundation

// this is model returned by calling https://barcode.monster/api/<barcode>
struct BarcodeProductDetails: Codable {
    let code: String
    let image_url: String?
    let name: String?
    let details: String?
    
}
