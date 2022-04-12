//
//  Dependencies.swift
//  Inventory Manager
//
//  Created by Marcin Ratajczak on 09/04/2022.
//  Copyright © 2022 A. All rights reserved.
//

import Foundation

struct AppDependencies {
    let databaseService: DatabaseService
    
    
    init(uid: String) {
        databaseService = DatabaseServiceImp(uid: uid)
    }
}
