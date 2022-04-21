//
//  ItemListDataSource.swift
//  Inventory Manager
//
//  Created by Marcin Ratajczak on 16/04/2022.
//  Copyright © 2022 A. All rights reserved.
//

import UIKit

class ItemListDataSource: NSObject, UITableViewDataSource {
    private var itemsArray: [DatabaseItem] = []
    private var locationsArray: [DatabaseItem] = []
    
    func updateItems(databaseItems: [DatabaseItem]) {
        itemsArray = databaseItems.filter{ $0.item.isLocation != true } // TODO: zmienić optionala "isLocation" na hard i zmienić ten warunek na czytelniejszy
        locationsArray = databaseItems.filter{ $0.item.isLocation == true }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var sectionsCount = itemsArray.isEmpty ? 0 : 1
        sectionsCount += locationsArray.isEmpty ? 0 : 1
        return sectionsCount
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let bothSections = (numberOfSections(in: tableView) == 2)
        switch section {
        case 0:
            return bothSections ? itemsArray.count : itemsArray.count + locationsArray.count
        case 1:
            return bothSections ? locationsArray.count : itemsArray.count + locationsArray.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: ItemCell.reuseIdentifier, for: indexPath) as! ItemCell
            let item = itemsArray[indexPath.row]
            cell.bind(with: item)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: ItemCell.reuseIdentifier, for: indexPath) as! ItemCell
            let item = locationsArray[indexPath.row]
            cell.bind(with: item)
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return itemsArray.isEmpty ? "Locations" : "Items"
        case 1:
            return "Locations"
        default:
            return ""
        }
    }
    
    
}
