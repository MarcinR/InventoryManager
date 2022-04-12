//
//  ItemDetailsViewController.swift
//  Inventory Manager
//
//  Created by Marcin Ratajczak on 10/04/2022.
//  Copyright © 2022 A. All rights reserved.
//

import UIKit

class ItemDetailsViewController: UITableViewController {
    
    @IBOutlet private var idLabel: UILabel!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var codeLabel: UILabel!
    @IBOutlet private var locationLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    // TODO: to nie powinno być przekazywane jako var
    var  item: InventoryItem?

    override func viewDidLoad() {
        super.viewDidLoad()
        if let item = self.item {
            setupWithItem(item: item)
        }
    }
    
    func setupWithItem(item: InventoryItem) {
        idLabel.text = item.id
        nameLabel.text = item.name
        codeLabel.text = item.code
        locationLabel.text = item.shelfID
        descriptionLabel.text = item.description
    }


}
